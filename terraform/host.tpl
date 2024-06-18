[${group}]
${name}.neto.local ansible_host=${ip} ansible_user=${user} type=${type} ansible_ssh_common_args='-J ubuntu@${ip_nat}' kub_ip=${kub_ip}