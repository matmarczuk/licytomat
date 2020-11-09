<template>    
    <div class="add_auction">
      <form v-on:submit="add_new_auction" id="add_new_form">
        <input style="width:80%; margin: 10px;" type="text" placeholder="Nazwa przedmiotu/usługi na licytację" id="auction_name" required> <br>
        <input type="text" placeholder="Opis" id="auction_description" required> <br>
        <label>Kategoria</label>
        <select style="margin: 10px;">
          <option>AGD</option>
          <option>Zabawki</option>
          <option>Książki</option>
          <option>Biżuteria</option>
          <option>Usługi</option>
        </select> <br>
        <label>Data zakończenia</label>
        <input type="date" id="auction_end" style="margin: 10px;"><br>
        <label>Miejscowość</label>
        <input type="text" style="margin: 10px;" placeholder="Miasto"> <br>
        <label>Cena startowa</label>
        <input style="margin: 10px;" type="number" placeholder="Cena startowa" id="auction_initial_price" step="5" required> <br>
        <button style="width:30%; margin: 10px; height:50px;" type="submit" id="add_auction_button">Dodaj</button>
      </form>
    </div>
     
</template>

<script>
import Vue from 'vue';
import axios from 'axios';
import VueAxios from 'vue-axios';

Vue.use(VueAxios,axios)
export default {
    name: "AddAuction",
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
      add_new_auction : function (event) {
        name = document.getElementById("add_new_form").elements;
        console.log(name['name']);
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