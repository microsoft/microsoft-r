import Vue from 'vue'
import Router from 'vue-router'
import ImageClassification from '@/components/ImageClassification'

Vue.use(Router)

export default new Router({
  routes: [
    {
      path: '/',
      name: 'ImageClassification',
      component: ImageClassification
    }
  ]
})
