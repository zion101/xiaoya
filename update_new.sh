if [ -d /etc/xiaoya/mytoken.txt ]; then
	rm -rf /etc/xiaoya/mytoken.txt
fi
mkdir -p /etc/xiaoya
touch /etc/xiaoya/mytoken.txt
touch /etc/xiaoya/myopentoken.txt
touch /etc/xiaoya/temp_transfer_folder_id.txt

mytokenfilesize=$(cat /etc/xiaoya/mytoken.txt)
mytokenstringsize=${#mytokenfilesize}
if [ $mytokenstringsize -le 31 ]; then
	echo -e "\033[32m"
	read -p "输入你的阿里云盘 Token（32位长）: " token
	token_len=${#token}
	if [ $token_len -ne 32 ]; then
		echo "长度不对,阿里云盘 Token是32位长"
		echo -e "安装停止，请参考指南配置文件\nhttps://xiaoyaliu.notion.site/xiaoya-docker-69404af849504fa5bcf9f2dd5ecaa75f \n"
		echo -e "\033[0m"
		exit
	else	
		echo $token > /etc/xiaoya/mytoken.txt
	fi
	echo -e "\033[0m"
fi	

myopentokenfilesize=$(cat /etc/xiaoya/myopentoken.txt)
myopentokenstringsize=${#myopentokenfilesize}
if [ $myopentokenstringsize -le 279 ]; then
	echo -e "\033[33m"
        read -p "输入你的阿里云盘 Open Token（280位长或者335位长）: " opentoken
	opentoken_len=${#opentoken}
        if [[ $opentoken_len -ne 280 ]] && [[ $opentoken_len -ne 335 ]]; then
                echo "长度不对,阿里云盘 Open Token是280位长或者335位"
		echo -e "安装停止，请参考指南配置文件\nhttps://xiaoyaliu.notion.site/xiaoya-docker-69404af849504fa5bcf9f2dd5ecaa75f \n"
		echo -e "\033[0m"
                exit
        else
        	echo $opentoken > /etc/xiaoya/myopentoken.txt
	fi
	echo -e "\033[0m"
fi

folderidfilesize=$(cat /etc/xiaoya/temp_transfer_folder_id.txt)
folderidstringsize=${#folderidfilesize}
if [ $folderidstringsize -le 39 ]; then
	echo -e "\033[36m"
        read -p "输入你的阿里云盘转存目录folder id: " folderid
	folder_id_len=${#folderid}
	if [ $folder_id_len -ne 40 ]; then
                echo "长度不对,阿里云盘 folder id是40位长"
		echo -e "安装停止，请参考指南配置文件\nhttps://xiaoyaliu.notion.site/xiaoya-docker-69404af849504fa5bcf9f2dd5ecaa75f \n"
		echo -e "\033[0m"
                exit
        else
        	echo $folderid > /etc/xiaoya/temp_transfer_folder_id.txt
	fi	
	echo -e "\033[0m"
fi

if [ $1 ]; then
if [ $1 == 'host' ]; then
	docker stop xiaoya-hostmode
	docker rm xiaoya-hostmode
	docker rmi xiaoyaliu/alist:hostmode
	docker pull xiaoyaliu/alist:hostmode
	if [[ -f /etc/xiaoya/proxy.txt ]] && [[ -s /etc/xiaoya/proxy.txt ]]; then
        	proxy_url=$(head -n1 /data/proxy.txt)
		docker run -d --env HTTP_PROXY="$proxy_url" --env HTTPS_PROXY="$proxy_url" --env no_proxy="*.aliyundrive.com" --network=host -v /etc/xiaoya:/data --restart=always --name=xiaoya-hostmode xiaoyaliu/alist:hostmode
	else	
		docker run -d --network=host -v /etc/xiaoya:/data --restart=always --name=xiaoya-hostmode xiaoyaliu/alist:hostmode
	fi	
	exit
fi
fi

docker stop xiaoya
docker rm xiaoya
docker rmi xiaoyaliu/alist:latest 
docker pull xiaoyaliu/alist:latest
if [[ -f /etc/xiaoya/proxy.txt ]] && [[ -s /etc/xiaoya/proxy.txt ]]; then
	proxy_url=$(head -n1 /data/proxy.txt)
       	docker run -d --env HTTP_PROXY="$proxy_url" --env HTTPS_PROXY="$proxy_url" --env no_proxy="*.aliyundrive.com" -v /etc/xiaoya:/data --restart=always --name=xiaoya xiaoyaliu/alist:latest
else
	docker run -d -p 1874:80 -v /etc/xiaoya:/data --restart=always --name=xiaoya xiaoyaliu/alist:latest
fi	

