# Подготовка базовой инфраструктуры

### Иницилизация terraform
	cd terraform_backend
	terraform init
	
### Создание профиля для подключения
	yc config profile create test_dip
	yc config set token Otoken
	yc iam key create --service-account-id S_id -o key.json
	yc config set service-account-key key.json
	yc config set cloud-id c_id
	yc iam create-token
Вносим токен в файл конфигурации  
Применяем конфигурацию

	terraform apply
В конце получаем output с данными для использования в следующих шагах.

# Разворачивание основной инфраструктуры

### Создание профиля для подключения для создания необходимых ресурсов

id сервиснуго аккаунта и папки берем из output предыдущего шага

	cd ..
	yc config profile create dip
	yc config set token Otoken
	yc iam key create --service-account-id <id> --folder-id <id> -o key.json
	yc config set service-account-key key.json
	yc config set cloud-id b1gej4e9d7o072iokarn
	yc iam create-token


### Иницилизируем терраформ с данными из output terraform

	terraform init -backend-config="access_key=$ACCESS_KEY" -backend-config="secret_key=$SECRET_KEY"


разворачиваем инфраструктуру  

	terraform apply

### Устанавливаем кластер Kubernetes

Переходим в папку Ansible  

	cd ../Ansible
    ansible-playbook main.yml -l k8s

### Устанавливаем Jenkins

	ansible-playbook jen.yml -l jenkins.neto.local

### Публикуем Jenkins

	ansible-playbook jen_pub.yaml -l nat-machine.neto.local

### Разворачиваем app

Меняем в файле "\~/.kube/config_diplom" ip адрес подключения на внешний адрес мастер ноды kubernetes  
Разворачиваем приложение  

	cd ../kuber_my
	kubectl apply --kubeconfig="~/.kube/config_diplom" -f .

### Разворачиваем moniroting

	cd ../kuber  
	kubectl apply --server-side -f setup --kubeconfig="~/.kube/config_diplom"
	kubectl apply --server-side -f . --kubeconfig="~/.kube/config_diplom"
	
   