<template>    
    <div class="add_auction">
      <form id="add_new_form" @submit.prevent="add_new_auction">
        <input style="width:80%; margin: 10px;" type="text" v-model="auctionItem.name" placeholder="Nazwa przedmiotu/usługi na licytację" id="auction_name" required> <br>
        <input type="text" v-model="auctionItem.desc" placeholder="Opis" id="auction_description" required> <br>
        <label>Kategoria</label>
        <select style="margin: 10px;" v-model="auctionItem.category">
          <option>AGD</option>
          <option>Zabawki</option>
          <option>Książki</option>
          <option>Biżuteria</option>
          <option>Usługi</option>
        </select> <br>
        <label>Data zakończenia</label>
        <input type="date" v-model="auctionItem.end_date" id="auction_end" style="margin: 10px;"><br>
        <label>Miejscowość</label>
        <input type="text" v-model="auctionItem.city" style="margin: 10px;" placeholder="Miasto"> <br>
        <input type="file" v-on:change="handle_file_upload" id="img" ref="file" accept="image/*">
        <label>Cena startowa</label>
        <input style="margin: 10px;" type="number"  v-model="auctionItem.start_bid" placeholder="Cena startowa" id="auction_initial_price" step="5" required> <br>
        <button style="width:30%; margin: 10px; height:50px;" type="submit" id="add_auction_button">Dodaj</button>
      </form>
    </div>
     
</template>

<script>
import Vue from 'vue';
import axios from 'axios';
import VueAxios from 'vue-axios';
import {API_ADDR} from '../variables.js';

Vue.use(VueAxios,axios)
export default {
    name: "AddAuction",
    data () {
      return {
        auctionItem : {
          aim: '',
          name : '',
          desc: '',
          category: '',
          end_date: '',
          city: '',
          start_bid: '',
          image: ''
        },
        imgToken : '',
      }
    },
    mounted() {
      const today = new Date()
      const in3days = new Date(today)
      const tomorrow = new Date(today)
      tomorrow.setDate(today.getDate() + 1)
      in3days.setDate(tomorrow.getDate() + 3)
      auction_end.max = in3days.toISOString().split('T')[0]
      auction_end.min = tomorrow.toISOString().split('T')[0]
    },
    methods : {
      async add_new_auction (event) {
        if(this.auctionItem.image) {
          await Vue.axios.get(API_ADDR+ '/auction/image/url' + '?imgType=' + this.auctionItem.image.name.split('.').pop())
          .then((resp)=>{
              this.imgToken = resp.data;
          })
          let formData = new FormData();
          Object.keys(this.imgToken.fields).forEach(key => {
            formData.append(key, this.imgToken.fields[key]);
          });
          formData.append('file',this.auctionItem.image);
          console.log(this.imgToken)

          await Vue.axios({
            method: 'POST',
            url: this.imgToken.url,
            data: formData,
            headers: {'Content-Type': 'multipart/form-data' }
            })
            .then(function (response) {
                //handle success
                console.log(response);
            })
            .catch(function (response) {
                //handle error
                console.log(response);
            });
            this.auctionItem.image=this.imgToken.url + this.imgToken.fields.key;
        }
        this.auctionItem.aim = 'Kubus'
        await Vue.axios.put(API_ADDR + '/auction',
        this.auctionItem)
        .then((response)=> {
          console.log("odpowiedz");
          console.log(response);
        })


        this.$router.push({ name: 'AuctionsList' })
      

      },
      get_preasign_image_url : function (event) {
        return Vue.axios.get(API_ADDR + '/image/url')
        .then((resp)=>{
            console.log("to jest w środku" + resp.data.body);
        })
        .catch((error) => {
          console.warn('erros : ',error);
        })  
      },
      handle_file_upload : function () {
        this.auctionItem.image = this.$refs.file.files[0];
        console.log(this.auctionItem.image);
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

#auction_description{
  width:80%; 
  height:100px; 
  margin: 10px; 
  word-wrap: break-word; 
  word-break: break-all;
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

.add_auction {
  margin-bottom: 0;
  border-radius: 0;
  background-color: #e6ecf1;
  margin: 20px;
  margin-left: auto;
  margin-right: auto;
  width: 70%;
  height: 50%;
}
</style>