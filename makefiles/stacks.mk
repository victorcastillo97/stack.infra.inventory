
STACK_TEMPLATES_PATH	= htps://s3.${BUCKET_INFRA_REGION}.amazonaws.com/${BUCKET_INFRA_STACK_PATH}
DEPLOY_REGION			= us-west-2

STACK_NETWORK_NAME 		= ${PROJECT_NAME}-NETWORK
STACK_NETWORK_PATH		= ./cloudformation/stacks/network/vpc.yml

network.create: #Create the network 
	@ aws cloudformation create-stack --stack-name ${STACK_NETWORK_NAME} \
	--template-body file://${STACK_NETWORK_PATH} \
	--parameters \
		ParameterKey=StackFilesPath,ParameterValue=${STACK_TEMPLATES_PATH} \
		ParameterKey=ProjectName,ParameterValue=${PROJECT_NAME}

	@ aws cloudformation wait stack-create-complete  \
	--stack-name ${STACK_NETWORK_NAME}

network.delete:
	@ aws cloudformation delete-stack --stack-name ${STACK_NETWORK_NAME}
	@ aws cloudformation wait stack-delete-complete --stack-name ${STACK_NETWORK_NAME}
	



STACK_TASK_DEFINITION_NAME 		= ${PROJECT_NAME}-TaskDefinition
STACK_TASK_DEFINITION_PATH		= ./cloudformation/stacks/task_definition/task_definition.yml

task.create: # Create the definition task
	@ aws cloudformation create-stack --stack-name ${STACK_TASK_DEFINITION_NAME} \
	--template-body file://${STACK_TASK_DEFINITION_PATH} \
	--parameters \
		ParameterKey=ProjectName,ParameterValue=${PROJECT_NAME} \
	--capabilities CAPABILITY_NAMED_IAM

	@ aws cloudformation wait stack-create-complete  \
	--stack-name ${STACK_TASK_DEFINITION_NAME}

task.delete:
	@ aws cloudformation delete-stack --stack-name ${STACK_TASK_DEFINITION_NAME}
	@ aws cloudformation wait stack-delete-complete --stack-name ${STACK_TASK_DEFINITION_NAME}

task.update:
	@ aws cloudformation update-stack --stack-name ${STACK_TASK_DEFINITION_NAME} \
	--template-body file://${STACK_TASK_DEFINITION_PATH} \
	--parameters \
		ParameterKey=ProjectName,ParameterValue=${PROJECT_NAME} \
	--capabilities CAPABILITY_NAMED_IAM
	@ aws cloudformation wait stack-update-complete --stack-name ${STACK_TASK_DEFINITION_NAME}




STACK_ALB_NAME 		= ${PROJECT_NAME}-ALB
STACK_ALB_PATH		= ./cloudformation/stacks/load_balancer/alb.yml

alb.create: # Create aplication load balancer and target group
	@ aws cloudformation create-stack --stack-name ${STACK_ALB_NAME} \
	--template-body file://${STACK_ALB_PATH} \
	--parameters \
		ParameterKey=StackFilesPath,ParameterValue=${STACK_TEMPLATES_PATH} \
		ParameterKey=ProjectName,ParameterValue=${PROJECT_NAME} \
		ParameterKey=PathExportVpcID,ParameterValue=${STACK_NETWORK_NAME}-vpc \
		ParameterKey=PathExportSubnetIDs,ParameterValue=${STACK_NETWORK_NAME}-subnets-publics

	@ aws cloudformation wait stack-create-complete  \
	--stack-name ${STACK_ALB_NAME}

alb.delete:
	@ aws cloudformation delete-stack --stack-name ${STACK_ALB_NAME}
	@ aws cloudformation wait stack-delete-complete --stack-name ${STACK_ALB_NAME}




STACK_ECS_NAME 		= ${PROJECT_NAME}-ECS
STACK_ECS_PATH		= ./cloudformation/stacks/ecs-cluster/service.yml

service.create:
	@ aws cloudformation create-stack --stack-name ${STACK_ECS_NAME} \
	--template-body file://${STACK_ECS_PATH} \
	--parameters \
		ParameterKey=StackFilesPath,ParameterValue=${STACK_TEMPLATES_PATH} \
		ParameterKey=ProjectName,ParameterValue=${PROJECT_NAME} \
		ParameterKey=PathExportVpcID,ParameterValue=${STACK_NETWORK_NAME}-vpc \
		ParameterKey=PathExportSubnetIDs,ParameterValue=${STACK_NETWORK_NAME}-subnets-privates \
		ParameterKey=PathExportLBTargetGroupArn,ParameterValue=${STACK_ALB_NAME}-TargetGroup-ARN \
		ParameterKey=PathExportALBSecurityGroupID,ParameterValue=${STACK_ALB_NAME}-ALBSecurityGroup-ID \
		ParameterKey=PathExportTaskDefinitionARN,ParameterValue=${STACK_TASK_DEFINITION_NAME}-TaskDefinition-ARN \
	--capabilities CAPABILITY_NAMED_IAM
		
	@ aws cloudformation wait stack-create-complete  \
	--stack-name ${STACK_ECS_NAME}

service.delete:
	@ aws cloudformation delete-stack --stack-name ${STACK_ECS_NAME}
	@ aws cloudformation wait stack-delete-complete --stack-name ${STACK_ECS_NAME}


