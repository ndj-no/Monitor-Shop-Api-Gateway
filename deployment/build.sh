#!/bin/bash

helpFunction()
{
   echo ""
   echo "Usage: $0 -s keyword -r"
   echo "    -s service: fe-admin (ad), fe-client (cl)"
   echo "                api gateway (gw), file service (f), auth service (au)"
   echo "                product service (pr), push service (psh)"
   echo "    -r flag to restart containers after cleaning logs"
   exit 1 # Exit script after printing help
}

p_service=""
while getopts ":s:p" opt
do
   case "$opt" in
      s ) p_service="$OPTARG" ;;
      p ) p_push_flag=false ;;
      ? ) helpFunction ;; # Print helpFunction in case parameter is non-existent
   esac
done

echo "'$p_service'"

IFS=',' read -r -a services <<< "$p_service"

for service in "${services[@]}"
do
    echo
    # FE: admin 
    if [ "$service" = "ad" ] || [ "$service" = "fe-admin" ]; then
        tag="giangndj/mshop:frontend-admin"
        echo "# FE -- frontend-admin: building..."
        docker build -f ./Dockerfile-fe --build-arg BUILD_MODE=dev -t $tag ../../Monitor-Shop-Admin-FrontEnd
        echo "# FE -- frontend-admin: build done"
        if [ "$p_push_flag" ]; then
            docker push $tag
            echo "# FE -- frontend-admin: pushed to dockerhub with tag: $tag"
        fi
    # FE: customer
    elif [ "$service" = "cl" ] || [ "$service" = "fe-client" ]; then
        tag=giangndj/mshop:frontend-customer
        echo "# FE -- frontend-client: building..."
        docker build -f ./Dockerfile-fe --build-arg BUILD_MODE=dev -t $tag ../../Monitor-Shop-FrontEnd
        echo "# FE -- frontend-client: build done"
        if [ "$p_push_flag" ]; then
            docker push $tag
            echo "# FE -- frontend-client: pushed to dockerhub with tag: $tag"
        fi
    # BE: gateway
    elif [ "$service" = "gw" ] || [ "$service" = "gateway" ]; then
        label="BE -- api-gateway-service"
        tag=giangndj/mshop:api-gateway-service
        echo "# $label: building..."
        docker build -f ./Dockerfile-be -t $tag ../../Monitor-Shop-Api-Gateway
        echo "# $label: build done"
        if [ "$p_push_flag" ]; then
            docker push $tag
            echo "# $label: pushed to dockerhub with tag: $tag"
        fi
    # BE: auth
    elif [ "$service" = "au" ] || [ "$service" = "auth" ]; then
        label="BE -- auth-service"
        tag=giangndj/mshop:auth-service
        echo "# $label: building..."
        docker build -f ./Dockerfile-be -t $tag ../../Monitor-Shop-Auth-Service
        echo "# $label: build done"
        if [ "$p_push_flag" ]; then
            docker push $tag
            echo "# $label: pushed to dockerhub with tag: $tag"
        fi
    # BE: file
    elif [ "$service" = "f" ] || [ "$service" = "file" ]; then
        label="BE -- file-service"
        tag=giangndj/mshop:file-service
        echo "# $label: building..."
        docker build -f ./Dockerfile-be -t $tag ../../Monitor-Shop-File-Service
        echo "# $label: build done"
        if [ "$p_push_flag" ]; then
            docker push $tag
            echo "# $label: pushed to dockerhub with tag: $tag"
        fi
    # BE: product
    elif [ "$service" = "pr" ] || [ "$service" = "product" ]; then
        label="BE -- product-service"
        tag=giangndj/mshop:product-service
        echo "# $label: building..."
        docker build -f ./Dockerfile-be -t $tag ../../Monitor-Shop-Product-Service
        echo "# $label: build done"
        if [ "$p_push_flag" ]; then
            docker push $tag
            echo "# $label: pushed to dockerhub with tag: $tag"
        fi
    # BE: push
    elif [ "$service" = "psh" ] || [ "$service" = "push" ]; then
        label="BE -- push-service"
        tag=giangndj/mshop:push-service
        echo "# $label: building..."
        docker build -f ./Dockerfile-be -t $tag ../../Monitor-Shop-Push-Service
        echo "# $label: build done"
    fi
done

