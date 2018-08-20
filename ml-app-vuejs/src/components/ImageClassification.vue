<template>
  <div class="container">
    <center>      
      <div id="login-container" class="large-12 medium-12 small-12 cell" v-if="access_token === null">
        <div class="form-group col-sm-3">
          <input type="text" class="form-control" id="username" v-model="username" placeholder="Enter username">
        </div>
        <div class="form-group col-sm-3">
          <input type="password" class="form-control" id="passwd" v-model="password" placeholder="Enter password">
        </div>
        <button type="button" class="btn btn-default" v-on:click="login()">Login</button>
      </div>

      <div v-if="access_token !== null">
        <canvas id="canvas" class="img-thumbnail" width=512 height=512></canvas>
        <div class="large-12 medium-12 small-12 cell">
          <label class="btn btn-lg">
            <span class="glyphicon glyphicon-camera"/>
            <input type="file" style="display: none;" class="form-control" accept="image/*;capture=camera" id="file" ref="file" v-on:change="handleImageUpload()"/>
          </label>
        </div>      
        <br />
        <div id="result">        
          <div class="alert alert-success" v-if="prediction !== null">
            <strong>{{prediction}}</strong>
          </div>
        </div>
      </div>      
    </center>
  </div>
</template>

<script>
export default {
  name: 'ImageClassification',
  data() {
    return {
      file: '',
      username: null,
      password: null,
      access_token: null,
      prediction: null
    }    
  },
  methods: {
    login() {
      const model = this;
      const image_classification = require('image_classification');
      const userApiClient = new image_classification.UserApi();

      // All API requests go to the same host:port as where the app is running at. Reverse proxy will re-route the API requests.
      // See proxyTable in config/index.js 
      image_classification.ApiClient.instance.basePath = '';

      const request = image_classification.LoginRequest.constructFromObject({
        username: model.username,
        password: model.password
      });

      userApiClient.login(
        request,
        (err, data, response) => {
          if (err) {            
            if(err.status === 401)
            {
              alert("Username or password is incorrect.");
            }
            console.error(err);
          } else {
            model.access_token = data.access_token;
          }

          model.password = '';
        });
    },
    handleImageUpload(e) {      
      const model = this;
      const image_classification = require('image_classification');
      var apiClient = image_classification.ApiClient.instance;
     
      // Configure API key authorization: Bearer
      var Bearer = apiClient.authentications['Bearer'];
      Bearer.apiKeyPrefix = 'Bearer ';
      Bearer.apiKey = model.access_token;      

      model.prediction = 'thinking...'; 
      model.file = this.$refs.file.files[0];
      const canvas = document.getElementById("canvas");
      const context = canvas.getContext("2d")
      const img = new Image(canvas.width, canvas.height);
      
      img.onload = () => {
        context.drawImage(img, 0, 0, canvas.width, canvas.height);        
        URL.revokeObjectURL(img.src);

        const classificationApi = new image_classification.ImageClassificationApi();
        const request = new image_classification.InputParameters.constructFromObject({
           image: canvas.toDataURL().replace(/^data:image\/(png|jpg);base64,/, '')
        });

        classificationApi.runInferenceOnImage(
          request,
          (err, data, response) => {
            if (err) {
              if(err.status === 401 || err.status === 403)
              {
                model.access_token = null; // nullify access token since it's no longer valid
              }
              console.error(err);              
            } else {              
              model.prediction = 'That seems to be ' 
                + (data.outputParameters.answer.match(/^[aeiou]/i) ? 'an ' : 'a ')
                + data.outputParameters.answer;
            }
          });
      };
      
      img.src = URL.createObjectURL(model.file);
    }
  }
}
</script>

<style>
#login-container {
  margin-top: 20px;
}

.glyphicon {
    font-size: 30px;
    color: darkgray;
}
</style>
