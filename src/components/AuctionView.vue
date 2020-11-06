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
        </tr>
    </div>
    <div class="bid_offer_box">
      <input type="text" id="new_offer" style="margin-top:15px; vertical-align:middle; text-align:center; width:40%;">
      <input type="submit" v-on:click="validate_input" value="Licytuj" style="float: right; margin-top:15px; margin-right:5px; width:35%" />
      <div class="validation_message" id="validation_message"></div>
    </div>
    <div class="bid_offer_box" v-for="bid in result.Bids.L" v-bind:key="bid.M.Offer.N">
      <h3>{{bid.M.Offer.N}}</h3>
    </div>
  </div>
</template>

<script>
import Vue from 'vue';
import axios from 'axios';
import VueAxios from 'vue-axios';

Vue.use(VueAxios,axios)
export default {
    name: "AuctionView",
    props: {'AuctionId': String},
    data()
    {
        return {result:undefined}
    },
    mounted()
    {   console.warn(this.AuctionId)
        Vue.axios.get('https://4twxv4ljuc.execute-api.eu-west-1.amazonaws.com/test/auction/' + this.$route.params.id)
        .then((resp)=>{
            console.warn(resp);
            this.result = resp.data.Item;
            this.bids = this.result.Bids.L.sort((a,b) => (Number(a.M.Offer.N) < Number(b.M.Offer.N)) ? 1 : -1);
            console.warn(this.bids)
        })
    },
    methods : {
      add_new_bid : function (event) {
        Vue.axios.put('https://4twxv4ljuc.execute-api.eu-west-1.amazonaws.com/test/auction/' + this.$route.params.id + '/bid', {'userId': 4, 'bid': document.getElementById('new_offer').value});
        location.reload();
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