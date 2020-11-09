import Vue from 'vue'
import Router from 'vue-router'
import HelloWorld from '@/components/HelloWorld'
import AuctionsList from '@/components/AuctionsList'
import AuctionView from '@/components/AuctionView'
import AddAuction from '@/components/AddAuction'

Vue.use(Router)

export default new Router({
  routes: [
    {
      path: '/',
      name: 'HelloWorld',
      component: HelloWorld
    },
    {
      path: '/auctions',
      name: 'AuctionsList',
      component: AuctionsList
    },
    {
      path: '/auction/:id',
      name: 'AuctionView',
      component: AuctionView,
      props: route => ({ AuctionId: route.query.q })
    },
    {
      path: '/add',
      name: 'AddAuction',
      component: AddAuction
    }
  ]
})
