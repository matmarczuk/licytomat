<template>
  <div class="auction_view">    
    <div class="detail_box">
        <tr style="width:100%; display:table;">
            <td width=150>
                <img :src="result.Images.L[0].S" alt="alternatetext" height="300px"/>
            </td>
            <td valign="top" style="text-align: left; padding-left: 15px;">
              <h2>{{result.Name.S}}</h2>
              <h3 style="text-align: left; padding-left: 15px;">{{result.Description.S}}</h3>
            </td>
        </tr>
        <tr valign="top">
          ok
        </tr>
    </div>
    <h2 style="text-align: left;">Oferty</h2>
    <div class="bid_offer_box">
      <input type="text" id="new_offer" style="margin-top:15px; vertical-align:middle; text-align:center; width:40%;">
      <input type="submit" v-on:click="validate_input" value="Licytuj" style="float: right; margin-top:15px; margin-right:5px; width:35%" />
      <div class="validation_message" id="validation_message"></div>
    </div>
    <div class="bid_offer_box" v-for="bid in result.Bids.L" v-bind:key="bid.M.Offer.N">
      <h3>{{bid.M.Offer.N}} zł</h3>
    </div>
    <div class="bid_offer_box" style="height:80px;">
      Oferta początkowa
      <h3>{{this.result.StartBid.N}} zł</h3>
    </div>
  </div>
</template>

<script>
import Vue from 'vue';
import axios from 'axios';
import VueAxios from 'vue-axios';
import {API_ADDR} from '../variables.js';

Vue.use(VueAxios,axios)
export default {
    name: "AuctionView",
    props: {'aim': String},
    data()
    {
      return {result:undefined}
    },
    mounted()
    { 
      this.get_auction_details()
    },
    methods : {
      async get_auction_details (event) {
        Vue.axios.get(API_ADDR + '/auction/' + this.$route.params.id)
        .then((resp)=>{
            console.warn(resp);
            this.result = resp.data;
            this.bids = this.result.Bids.L.sort((a,b) => (Number(a.M.Offer.N) < Number(b.M.Offer.N)) ? 1 : -1);
            console.warn(this.bids)
        })
      },
      async add_new_bid (event) {
        await Vue.axios.put(API_ADDR + '/auction/' + this.$route.params.id + '/bid', {'aim': this.result.Aim.S,'userId': 4, 'bid': document.getElementById('new_offer').value})
        .then((resp)=>{
          console.log("Response z put" + resp);
        })
        .catch(function (response) {
          //handle error
          console.log(response);
        });
        this.get_auction_details();
        this.$forceUpdate();
      },
      validate_input : function (event) {
        this.input = document.getElementById('new_offer').value;
        if (isNaN(this.input) || this.input < 0) //todo validate minimum bid 
        {
          alert("Proszę wpisać liczbę większą od 0");
          document.getElementById('new_offer').style["border"] = "2px solid red";
        }
        else
        {
          this.add_new_bid();
        }
      }
    }
}

</script>

<style>
html, body {
  height: 100%;
  padding-top: 10px;
  background: #01741a;
}
.auction_view {
  width: 100%;
}
.detail_box {
  margin-bottom: 0;
  border-radius: 0;
  background-color: #e6ecf1;
  margin: 10px;
  margin-left: 30px;
  width: 70%;
  min-width: 50%;
  height: 600px;
  float: left;
}
.bid_offer_box {
  margin-bottom: 0;
  border-radius: 0;
  background-color: #e6ecf1;
  margin: 10px;
  margin-right: auto;
  width: 15%;
  height: 50px;
  float: left;
}
.validation_message {
  font-size: 10px;
  color: red;
}
#app img {
  border-radius: 30px;
}
</style>