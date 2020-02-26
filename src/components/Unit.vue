<template>
  <div class="product product_horizontal">
    <span class="product_code">Код: {{ parseInt(unit.code) }}</span>
    <div class="product_status_tooltip_container">
      <span class="product_status">Наличие</span>
    </div>
    <div class="product_photo">
      <a href="#" class="url--link product__link">
        <img v-bind:src="GetUnitImgUrl" />
      </a>
    </div>
    <div class="product_description">
      <a href="#" class="product__link">{{ unit.title }}</a>
    </div>
    <div class="product_tags hidden-sm">
      <p>Могут понадобиться:</p>
      <AssocProducts
        v-for="product in AssocProductList"
        :name="product"
        :key="product.length + Math.random()"
      />
    </div>
    <div class="product_units">
      <div class="unit--wrapper">
        <div class="unit--select" v-bind:class="{ 'unit--active': !isFullPrice }">
          <p class="ng-binding" id="select-metr" @click="setPriceTypeAlt">За м. кв.</p>
        </div>
        <div class="unit--select" v-bind:class="{ 'unit--active': isFullPrice }">
          <p class="ng-binding" id="select-unit" @click="setPriceTypeFull">За упаковку</p>
        </div>
      </div>
    </div>
    <p class="product_price_club_card">
      <span class="product_price_club_card_text">
        По карте
        <br />клуба
      </span>
      <span class="goldPrice">{{ GetUnitGoldPrice }}</span>
      <span class="rouble__i black__i">
        <svg
          version="1.0"
          id="rouble__b"
          xmlns="http://www.w3.org/2000/svg"
          x="0"
          y="0"
          width="30px"
          height="22px"
          viewBox="0 0 50 50"
          enable-background="new 0 0 50 50"
          xml:space="preserve"
        >
          <use xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="#rouble_black" />
        </svg>
      </span>
    </p>
    <p class="product_price_default">
      <span class="retailPrice">{{ GetUnitPrice }}</span>
      <span class="rouble__i black__i">
        <svg
          version="1.0"
          id="rouble__g"
          xmlns="http://www.w3.org/2000/svg"
          x="0"
          y="0"
          width="30px"
          height="22px"
          viewBox="0 0 50 50"
          enable-background="new 0 0 50 50"
          xml:space="preserve"
        >
          <use xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="#rouble_gray" />
        </svg>
      </span>
    </p>
    <div class="product_price_points">
      <p class="ng-binding">Можно купить за 231,75 балла</p>
    </div>
    <div class="list--unit-padd"></div>
    <div class="list--unit-desc">
      <div class="unit--info">
        <div class="unit--desc-i"></div>
        <div class="unit--desc-t">
          <p>
            <span class="ng-binding">Продается упаковками:</span>
            <span class="unit--infoInn">1 упак. = {{ unit.unitRatioAlt }} м. кв.</span>
          </p>
        </div>
      </div>
    </div>
    <div class="product__wrapper">
      <div class="product_count_wrapper">
        <div class="stepper">
          <input
            class="product__count stepper-input"
            type="text"
            v-model="productCounter"
            @change="changeProductCounter"
          />
          <span @click="setProductCounterUp" class="stepper-arrow up"></span>
          <span @click="setProductCounterDown" class="stepper-arrow down"></span>
        </div>
      </div>
      <span
        class="btn btn_cart"
        data-url="/cart/"
        data-product-id="9bf0afd7-5190-11e5-b9a9-00259036a192"
      >
        <svg class="ic ic_cart">
          <use xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="#cart" />
        </svg>
        <span class="ng-binding" :data-product-id="unit.productId">В корзину</span>
      </span>
    </div>
  </div>
</template>

<script>
import AssocProducts from "./AssocProducts";

const PRICE_FORMAT = {
  unitFull: 1, // за упаковку
  unitAlt: 2 // за метр квадратный
};

export default {
  name: "Unit",
  components: {
    AssocProducts
  },

  props: {
    unit: Object
  },

  data: function() {
    return {
      priceFormat: PRICE_FORMAT.unitAlt,

      productCounter: 1
    };
  },

  computed: {
    isFullPrice: {
      get: function() {
        return this.priceFormat === PRICE_FORMAT.unitFull;
      }
    },

    // геттер вычисляемого значения
    AssocProductList: {
      get: function() {
        const productArray = this.unit.assocProducts.split(";");
        const productList = productArray.map((item, i) => {
          return i < productArray.length - 2
            ? `${item.trim()}, `
            : `${item.trim()}`;
        });

        return productList;
      }
    },

    // формируел URL изображения
    GetUnitImgUrl: {
      get: function() {
        return `http:${this.unit.primaryImageUrl}`; //.substring(0, unit.primaryImageUrl.lenght - 4)}_220x220_1.jpg`;
      }
    },

    // определяем текущий вормат цены
    GetUnitGoldPrice: {
      get: function() {
        // определим значение стоимости в зависимости от выбранного типа фасовки продукта
        const price =
          this.priceFormat === PRICE_FORMAT.unitFull
            ? this.unit.priceGold
            : this.unit.priceGoldAlt;

        return parseFloat((price * this.productCounter).toFixed(4));
      }
    },

    // получаем вариант текущей цены
    GetUnitPrice: {
      get: function() {
        // определим значение стоимости в зависимости от выбранного типа фасовки продукта
        const price =
          this.priceFormat === PRICE_FORMAT.unitFull
            ? this.unit.priceRetail
            : this.unit.priceRetailAlt;

        return parseFloat((price * this.productCounter).toFixed(4));
      }
    }
  },

  methods: {
    setProductCounterUp: function() {
      this.productCounter < 99 && this.productCounter++;
    },
    setProductCounterDown: function() {
      this.productCounter > 0 && this.productCounter--;
    },
    changeProductCounter: function(val) {
      if (val.target.value > 99) this.productCounter = 99;
      if (val.target.value < 0) this.productCounter = 0;

      this.productCounter = Math.floor(val.target.value);
    },
    setPriceTypeAlt: function() {
      this.priceFormat = PRICE_FORMAT.unitAlt;
    },

    setPriceTypeFull: function() {
      this.priceFormat = PRICE_FORMAT.unitFull;
    }
  }
};
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
</style>
