<template>
  <div class="home">
    <div class="home-header">
      <img class="home-header-img" src="../assets/img/home_icon.png" alt="">
      <div class="home-header-info">
        Welcome to CherrySafe
      </div>
    </div>
    <div class="home-nav-box">
      <div class="item">
        <div class="name">
          Create Safe
        </div>
        <div class="content">
          <p>Create a new Safe Multisig that is controlled by one or multiple owners.</p>
          <p>You will be required to pay a network fee for creating your new Safe.</p>
        </div>
        <div class="operate-btn" @click="$router.push('/creator')">
          Create new Safe
        </div>
      </div>
      <div class="item">
        <div class="name">
          My Safe
        </div>
        <div class="content">
        <p style="height: 110px">
          check my existing Safe
        </p>
        </div>
        <div class="operate-btn" @click="$router.push('/myMultisign')">
          Check Safe
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: "home"
}
</script>

<style scoped lang="scss">
.home{
  width: 1200px;
  margin: 0 auto;
  .home-header{
    position: relative;
    .home-header-img{
      width: 450px;
      height: 280px;
      margin-top: 20px;
      margin-left: calc(50% - 225px);
    }
    .home-header-info{
      width: 1200px;
      text-align: justify;
      color: #ffffff;
      top: calc(40%);
      font-weight: bold;
      font-size: 38px;
      position: absolute;
      letter-spacing: 35px;
      &::after{
        width: 100%;
        content: '';
        display: inline-block;
      }
    }
  }
  .home-nav-box{
    display: flex;
    justify-content: space-between;
    padding: 20px 0;
    .item{
      width: 550px;
      background: #243045;
      box-shadow: 0px 6px 30px 10px rgba(0, 0, 0, 0.15);
      border-radius: 30px;
      border: 1px solid #4A4A4A;
      padding: 30px;
      .name{
        font-size: 26px;
        line-height: 60px;
        text-align: center;
      }
      .content{
        color: #999;
        font-size: 18px;
        p{
          line-height: 30px;
        }
      }
      .operate-btn{
        width: 450px;
        height: 60px;
        margin: 30px auto;
        user-select: none;
        cursor: pointer;
        font-size: 20px;
        background: linear-gradient(90deg, #B4599F 0%, #B4008C 100%);
        border-radius: 10px;
        text-align: center;
        line-height: 60px;
      }
    }
  }
}
</style>
