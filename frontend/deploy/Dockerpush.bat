@echo on
CHCP 65001

docker build -t registry.cn-shenzhen.aliyuncs.com/xiix_cn/xiix_gais_team_web:latest ..

echo "Y11Br8wBK1GRSQBvi7ty" | docker login --username=xlnet@xiix --password-stdin registry.cn-shenzhen.aliyuncs.com

docker push registry.cn-shenzhen.aliyuncs.com/xiix_cn/xiix_gais_team_web:latest

docker logout registry.cn-shenzhen.aliyuncs.com

@REM 改为LF
