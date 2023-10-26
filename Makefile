.DEFAULT_GOAL := help

include makefiles/stacks.mk

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


