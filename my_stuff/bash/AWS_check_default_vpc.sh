#!/bin/bash

# En el hipotético caso en el que te podés parar en una cuenta de AWS con Organization y member Accounts,
# este script browsea account por account en todas las regiones que tenga permitidas buscando
# las VPCs, sus subnets y los Internet Gateways que tenga attacheados; y si tiene el CIDR range default,
# trata de borrar todo eso. De yapa hace un reporte con formato CSV pero no sirve como CSV porque
# el output también muestra los comandos que se tiran para borrar las cosas EN ROJO FURIOSO.

# Nota: Los comandos reales destructivos están comentados. Descomentalos para que rompa. Pero OJO

# BUGS:
# - La variable DO no está bien implementada. Empecé con una idea ahí pero la abandoné
# - La management account tira un error de que no se puede asumir el rol. Se podría agregar el rol para
#   autoasumirse, o mejorar el IF

#vars
ROLE="OrganizationAccountAccessRole"
SESSION_NAME="vcp-check@cli"
DO=1


# main
if [[ "${AWS_ACCESS_KEY_ID}" == "" ]]; then
	echo Error: No AWS session found
	exit 1
fi


ORIGINAL_ACCESS_KEY="${AWS_ACCESS_KEY_ID}"
## iterate all the account
aws organizations list-accounts --query "Accounts[].[Id, Name]" --output text |
	while IFS=$'\t' read -r id name; do
		(
			## assume a valid role in each account
			eval $(aws sts assume-role \
				--role-arn "arn:aws:iam::${id}:role/${ROLE}" \
				--role-session-name "${SESSION_NAME}" \
				--query 'Credentials.[AccessKeyId,SecretAccessKey,SessionToken]' \
				--output text | \
				awk '{print "export AWS_ACCESS_KEY_ID="$1" AWS_SECRET_ACCESS_KEY="$2" AWS_SESSION_TOKEN="$3}' \
			)
			if [[ "${ORIGINAL_ACCESS_KEY}" == "${AWS_ACCESS_KEY_ID}" ]]; then
				echo "Skipping account ${id}:${name}"
				exit
			fi
			## with that role, iterate among the authorized regions
			for region in $(aws ec2 describe-regions --query "Regions[].RegionName" --output text); do
				for vpc in $(aws ec2 describe-vpcs --region $region --query "Vpcs[].VpcId" --output text); do
					cidr=$(aws ec2 describe-vpcs --region $region \
						--filters "Name=vpc-id, Values=${vpc}" \
						--query "Vpcs[].CidrBlockAssociationSet[].CidrBlock" \
						--output text)
					echo "${id},${name},${region},${vpc},${cidr}"
					if [[ "${cidr}" == "172.31.0.0/16" && "$DO" == "1" ]]; then
						#DO=0
						echo -n -e "\033[37;41m"

						for subnet in $( aws ec2 describe-subnets \
							--region ${region} \
							--filters Name=vpc-id,Values=${vpc} \
							--query="Subnets[].SubnetId" \
							--output text | tr '\t' '\n'
						); do
							echo aws ec2 delete-subnet --region ${region} --subnet-id ${subnet}
							#aws ec2 delete-subnet --region ${region} --subnet-id ${subnet}
						done

						for igw in $( aws ec2 describe-internet-gateways \
							--region ${region} \
							--query "InternetGateways[].InternetGatewayId" \
							--filter "Name=attachment.vpc-id,Values=${vpc}" \
							--output text | tr '\t' '\n'
						); do
							echo "detach-internet-gateway ${igw} ${region} from ${vpc} AND THEN delete-internet-gateway ${igw}"
							#aws ec2 detach-internet-gateway \
							#	--internet-gateway-id ${igw} \
							#	--region ${region} \
							#	--vpc-id ${vpc} && \
							#	aws ec2 delete-internet-gateway \
							#		--internet-gateway-id ${igw} \
							#		--region ${region}
						done

						echo aws ec2 delete-vpc --region ${region} --vpc-id ${vpc}
						#aws ec2 delete-vpc --region ${region} --vpc-id ${vpc}
						echo -e "\033[0m"
					fi
				done
			done
		)
	done

