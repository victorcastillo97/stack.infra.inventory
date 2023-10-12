.DEFAULT_GOAL := help

include makefiles/stack.mk

OWNER          	= inventory
TYPE_APP        = app
SERVICE_NAME    = management
ENV             ?= dev
REGION 			= us-west-2

PROJECT_NAME    		= ${OWNER}-${TYPE_APP}-${SERVICE_NAME}-${ENV}

BUCKET_INFRA_REGION		= us-west-2
BUCKET_INFRA			= infra.stacks.${ENV}.2
BUCKET_INFRA_STACK_PATH	= ${BUCKET_INFRA}/cloudformation/${OWNER}/${ENV}/${PROJECT_NAME}

STACK_DIR_LOCAL			= ./cloudformation/templates

stacks.migrate:
	@ aws s3 cp ${STACK_DIR_LOCAL} s3://${BUCKET_INFRA_STACK_PATH} --recursive 

create:
	@ aws cloudformation create-stack --stack-name vpc-create \
	--template-body file://./cloudformation/stacks/network/vpc.yml \
	--parameters \
		ParameterKey=StackFilesPath,ParameterValue=htps://s3.${BUCKET_INFRA_REGION}.amazonaws.com/${BUCKET_INFRA_STACK_PATH} \
		ParameterKey=ProjectName,ParameterValue=${PROJECT_NAME}

	@ aws cloudformation wait stack-create-complete  \
	--stack-name vpc-create

delete:
	@ aws cloudformation delete-stack --stack-name vpc-create
	@ aws cloudformation wait stack-delete-complete --stack-name vpc-create

create.rest:
	@ aws cloudformation create-stack --stack-name vpc-rest \
		--template-body file://./cloudformation/stacks/network/vpc-rest.yml \
		--parameters \
			ParameterKey=StackFilesPath,ParameterValue=htps://s3.${BUCKET_INFRA_REGION}.amazonaws.com/${BUCKET_INFRA_STACK_PATH}

	@ aws cloudformation wait stack-create-complete --stack-name vpc-rest

delete.rest:
	@ aws cloudformation delete-stack --stack-name vpc-rest
	@ aws cloudformation wait stack-delete-complete --stack-name vpc-rest

delete.complete:
	@ aws cloudformation delete-stack --stack-name vpc-rest
	@ aws cloudformation delete-stack --stack-name vpc-create