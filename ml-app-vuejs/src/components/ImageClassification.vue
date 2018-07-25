<template>
  <div class="container">
    <center>
      <canvas id="canvas" class="img-thumbnail" width=512 height=512></canvas>
      <div class="large-12 medium-12 small-12 cell">
        <input type="file" class="form-control" accept="image/*" capture id="file" ref="file" v-on:change="handleFileUpload()"/>                
      </div>
      <br />
      <div id="result">        
        <div class="alert alert-success" v-if="prediction !== null">
          <strong>{{prediction}}</strong>
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
      prediction: null
    }
  },
  methods: {    
    handleFileUpload(e) {
      const axios = require('axios');
      const self = this;
      self.prediction = 'thinking...'; 
      self.file = this.$refs.file.files[0];
      const canvas = document.getElementById("canvas");
      const context = canvas.getContext("2d")
      var img = new Image(canvas.width, canvas.height);
      
      img.onload = function() {
        context.drawImage(img, 0, 0, canvas.width, canvas.height);        
        URL.revokeObjectURL(img.src);
        var imageData = canvas.toDataURL().replace(/^data:image\/(png|jpg);base64,/, '');

        axios.post(
          '/api/ImageClassification/1.0.0', // proxy routing configured by proxyTable in config/index.js
          {
            image: imageData
          },
          {
            headers: {
              // todo: replace with valid token, or login & generate token in the code on the fly
              'Authorization': 'Bearer ...',
              'Content-Type': 'application/json'
            }
          })
          .then(response => {
            self.prediction = 'It seems to be a ' + response.data.outputParameters.answer;
          })
          .catch(err => console.log(err.response));
      };
      
      img.src = URL.createObjectURL(self.file);
    }
  }
}
</script>

<style>

</style>
