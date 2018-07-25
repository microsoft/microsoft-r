<template>  
  <div id="app">    
    <header>
      <nav>
        <div class="container">
          <h1>Machine Learning App</h1>
        </div>          
      </nav>
    </header>
    <router-view/>
  </div>
</template>

<script>
export default {
  name: 'App'
}
</script>

<style>
#app {
  font-family: 'Avenir', Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;  
  margin-top: 20px;
}

header h1 {
  color: white;
  background-color: skyblue;
  margin: 2px;
  font-size: 1.6em;
  font-weight: 200;
}
</style>
