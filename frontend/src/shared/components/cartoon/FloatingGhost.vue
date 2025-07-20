<script setup lang="ts">
defineOptions({ name: 'CartoonFloatingGhost' })
</script>

<template>
  <div class="ghost">
    <div class="body">
      <div class="face">
        <div class="eye left" />
        <div class="eye right" />
        <div class="smile" />
        <div class="left rosy" />
        <div class="rosy right" />
      </div>
      <div class="left arm" />
      <div class="arm right" />
      <div class="bottom">
        <div />
        <div />
        <div />
        <div />
        <div />
      </div>
    </div>
    <div class="shadow" />
  </div>
</template>

<style scoped>
.ghost {
  position: relative;
  width: 110px;
  height: 135px;
}

.ghost .body {
  position: relative;
  width: 110px;
  height: 135px;
  border-top-right-radius: 80px;
  border-top-left-radius: 80px;
  background-color: #f0efda;
  animation: float 4s ease infinite;
}

.ghost .body .face {
  display: flex;
  flex-wrap: wrap;
  position: absolute;
  top: 37px;
  left: 22px;
  width: 72px;
  height: 41px;
}

.ghost .body .face .eye {
  width: 20px;
  height: 20px;
  border-radius: 100%;
  background-color: #272b24;
}

.ghost .body .face .eye.left {
  margin-right: 32px;
}

.ghost .body .face .smile {
  margin-top: 6px;
  width: 32px;
  height: 16px;
  margin-left: 20px;
  border-bottom-left-radius: 16px 12px;
  border-bottom-right-radius: 16px 12px;
  border-top-left-radius: 4px;
  border-top-right-radius: 4px;
  background-color: #272b24;
}

.ghost .body .face .rosy {
  position: absolute;
  top: 28px;
  width: 22px;
  height: 8px;
  border-radius: 100%;
  background-color: #ffaa9e;
}

.ghost .body .face .rosy.left {
  left: -6px;
  transform: rotate(-8deg);
}

.ghost .body .face .rosy.right {
  right: -6px;
  transform: rotate(8deg);
}

.ghost .body .arm {
  position: absolute;
  top: 76px;
  width: 60px;
  height: 40px;
  background-color: #f0efda;
}

.ghost .body .arm.left {
  left: -4px;
  border-radius: 60% 100%;
  animation: arms-left 4s ease infinite;
}

.ghost .body .arm.right {
  right: -65px;
  border-radius: 100% 60%;
  animation: arms-right 4s ease infinite;
}

.ghost .body .bottom {
  display: flex;
  position: absolute;
  top: 100%;
  left: 0px;
  right: -1px;
}

.ghost .body .bottom div {
  flex-grow: 1;
  position: relative;
  top: -14px;
  height: 28px;
  border-radius: 100%;
  background-color: #f0efda;
}

.ghost .body .bottom div:nth-child(2n) {
  top: -10px;
  margin: 0 -2px;
  border-top: 10px solid #f0efda;
  background: transparent;
}

.shadow {
  position: absolute;
  bottom: -35px;
  left: 50%;
  width: 140px;
  height: 12px;
  border-radius: 100%;
  background-color: #333;
  animation: shadow 4s ease infinite;
}

@keyframes float {
  0%,
  100% {
    top: 0px;
  }

  40% {
    top: -40px;
  }
}

@keyframes arms-left {
  0%,
  100% {
    transform: translate(-50%, -50%) rotate(50deg);
  }

  40% {
    transform: translate(-50%, -50%) rotate(40deg);
  }
}

@keyframes arms-right {
  0%,
  100% {
    transform: translate(-50%, -50%) rotate(-50deg);
  }

  40% {
    transform: translate(-50%, -50%) rotate(-40deg);
  }
}

@keyframes shadow {
  0%,
  100% {
    transform: translateX(-50%) scale(1);
  }

  40% {
    transform: translateX(-50%) scale(0.5);
  }
}
</style>
