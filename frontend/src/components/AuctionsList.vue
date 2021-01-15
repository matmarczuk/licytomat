<template>    
    <div id="app">
            <div class="box" v-for="item in result" v-bind:key="item.Id">
                <tr style="width:100%; display:table;">
                    <td width="150">
                        <img :src="item.Images.L[0].S" alt="alternatetext" height="150px"/>
                    </td>
                    <td valign="middle" style="text-align: left; padding-left: 15px;">
                    <router-link :to="{ name: 'AuctionView', params:{ id:`${item.Id.S}`} }">{{item.Name.S}}</router-link>           
                    </td>
                    <td valign="middle" width="150">
                        <h3>Aktualna cena <br/> {{item.Bids.L[0].M.Offer.N}} zł</h3>
                    </td>
                </tr>
      </div>
    </div>
     
</template>

<script>
import Vue from 'vue';
import axios from 'axios';
import VueAxios from 'vue-axios';
import {API_ADDR, API_STAGE} from '../variables.js';

Vue.use(VueAxios,axios)
export default {
    name: "AuctionsList",
    props: {'aim': String},
    data()
    {
        return {result:undefined}
    },
    mounted()
    { 
      Vue.axios.get(API_ADDR + API_STAGE + '/' + 'Kubus' + '/auctions')
        .then((resp)=>{
            console.log(API_ADDR + API_STAGE + '/' + 'Kubus' + '/auctions');
            this.result = resp.data.Items
        })
    }
}

</script>

<style>
    html, body {
  height: 100%;
  padding-top: 10px;
  background: #01741a;
}

#app {
  height: 100%;
  padding-top: 0px;
  text-align: center;
}

#app .button {
  margin-bottom: 20px;
}

.tweet {
  margin: 0 auto;
  padding-bottom: 15px;
}

.box {
  margin-bottom: 0;
  border-radius: 0;
  background-color: #e6ecf1;
  margin: 20px;
  margin-left: auto;
  margin-right: auto;
  width: 70%;
  height: 150px;
}

#app img {
  border-radius: 30px;
}

#app .level-item {
  padding-left: 10px;
  color: #00d1b2;
}

#app .tweets-move {
  transition: transform 1s;
}
</style>