<template>
  <div class="erc20Factory">
    <div class="title">
      Create New Safe
    </div>
    <div class="cherrySafe-panel">
      <div class="info">
        Owners and Confirmations
      </div>
      <div class="src20-form">
        <div class="item">
          <div class="title">
            manageArr
          </div>
          <div class="address-list">
            <div class="item" v-for="index in form.minSignCount" :key="index">
              <div class="input">
                <input type="text" v-model="form.manageArr[index-1]" :placeholder="'address'+index">
              </div>
            </div>
          </div>
          <div class="add-btn" @click="form.minSignCount++">
            Add
          </div>
        </div>
        <div class="item">
          <div class="title">
            minSignCount
          </div>
          <div class="count-box">
            <div class="count-info">Any transaction requires the confirmation of:</div>
            <div class="input-box">
              <div class="input">
                {{form.minSignCount}}
              </div>
              out of 2 owner(s)

            </div>
          </div>
        </div>

      </div>
      <div class="create" @click="create">
        Create
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: "erc20Factory",
  data() {
    return {
      form: {
        minSignCount:1,
        manageArr: []
      }
    }
  },
  methods: {

    create() {
      if (!this.$store.state.app.account) {
        this.$message.error("not connected")
        return
      }
      let loading = this.$loading()
      try {
        this.$store.dispatch("creator/creatNewMultiSign", this.form).then(() => {
          this.$message.success("success")
          loading.close()
          setTimeout(() => {
            this.$router.push({
              path: "myMultiSign"
            })
          }, 500)
        }).catch((err) => {
          loading.close()
          this.$message.error(err)
        })
      } catch (err) {
        loading.close()
        this.$message.error(err)
      }
    }
  }
}
</script>

<style lang="scss" scoped>
.erc20Factory {
  .title{
    margin-top: 30px;
    text-align: center;
    font-weight: bold;
    font-size: 30px;
    line-height: 50px;
  }
  .cherrySafe-panel {
    width: 1000px;
    background: #243045;
    box-shadow: 0px 6px 30px 10px rgba(0, 0, 0, 0.15);
    border-radius: 30px;
    border: 1px solid #4A4A4A;
    margin: 30px auto;
    padding: 30px;
  }



  .info {
    text-align: center;
    font-weight: 500;
    font-size: 20px;
    line-height: 24px;
  }

  .src20-form {
    .item {
      text-align: center;
      .title {
        font-size: 16px;
        line-height: 30px;
        font-weight: 700;
      }

      .input {
        input {
          padding-left: 10px;
          width: 480px;
          height: 50px;
          color: #fff;
          background: #182338;
          border: none;
          border-radius: 10px;
        }
      }
      .count-box{
        width: 470px;
        margin: 0 auto;
        text-align: left;
        .count-info{
          padding: 10px 0 0;
        }
        .input-box{
          padding: 10px 0;
          display: flex;
          align-items: center;
        }
        .input{
          width: 160px;
          height: 36px;
          line-height: 36px;
          text-align: center;
          background: #182338;
          border-radius: 10px;
        }
      }
    }

    .address-list {
      .item {
        margin-top: 20px;
      }
    }

    .add-btn {
      width: 130px;
      height: 40px;
      background: linear-gradient(90deg, #B4599F 0%, #B4008C 100%);
      text-align: center;
      line-height: 40px;
      font-weight: normal;
      cursor: pointer;
      user-select: none;
      border-radius: 10px;
      font-size: 20px;
      margin: 10px 230px;
    }
  }

  .create {
    text-align: center;
    width: 220px;
    height: 50px;
    background: linear-gradient(90deg, #B4599F 0%, #B4008C 100%);
    border-radius: 10px;
    cursor: pointer;
    margin: 20px auto;
    user-select: none;
    font-size: 20px;
    line-height: 50px;
    color: #fff;
  }
}
</style>
