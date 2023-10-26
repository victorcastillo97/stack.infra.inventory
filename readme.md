# Despliegue de Infraestructura en AWS para app Contenerizada en ECS Fargate

Este proyecto tiene como objetivo crear una infraestructura robusta en AWS para desplegar aplicaciones contenerizadas en ECS Fargate, priorizando la alta disponibilidad. Esto incluye la configuración de un VPC, subredes, instancias NAT, un Application Load Balancer (ALB), un Target Group y políticas de escalabilidad automática para garantizar un rendimiento óptimo y una experiencia ininterrumpida del usuario.

## Estructura de carpetas

root/
|   
├── cloudformation/
|   ├── stacks/
|   |   ├── ecs-app/
|   |   |   ├── dev/
|   |   |   ├── qa/
|   |   |   ├── prod/
|   |   ├── ecs-cluster/
|   |   |   ├── service.yml
|   |   |   ├── parameters.yml
|   |   ├── network/
|   |   |   ├── vpc.yml
|   |   |   ├── parameters.yml
|   ├── templates/
|   |   ├── common/
|   |   ├── ecs/
|   |   ├── network/
|   |   ├── security/
├── makefiles/
├── Makefile
├── readme.md


## Variables del Proyecto

Aquí están las variables utilizadas en el Makefile:

- **OWNER**: El propietario del proyecto.
- **TYPE_APP**: El tipo de aplicación.
- **SERVICE_NAME**: El nombre del servicio.
- **ENV**: El entorno de implementación (por defecto es "dev").
- **PROJECT_NAME**: El nombre del proyecto construido a partir de las variables anteriores.
- **BUCKET_INFRA_REGION**: La región de AWS donde se creará el bucket S3 de infraestructura.
- **BUCKET_INFRA**: El nombre del bucket S3 de infraestructura.
- **BUCKET_INFRA_STACK_PATH**: La ruta dentro del bucket S3 donde se almacenarán los archivos de CloudFormation.

## Requisitos Previos

Antes de comenzar, asegúrate de tener configurados los siguientes elementos:

1. **Credenciales de AWS**: Asegúrate de que tienes las credenciales de AWS configuradas correctamente en tu entorno local.

## Configuración del Proyecto

1. Clona este repositorio a tu máquina local.

```bash
git clone <URL_del_repositorio>
cd <nombre_del_repositorio>
```
2. Configura las variables del proyecto en el archivo Makefile según sea necesario. Asegúrate de ajustar las rutas, nombres y regiones de acuerdo a tus preferencias.

STACK_DIR             = ./cloudformation/templates
BUCKET_INFRA_REGION   = us-west-2
BUCKET_INFRA          = infra.stacks.dev.2
BUCKET_INFRA_STACK_PATH = ${BUCKET_INFRA}/cloudformation/inventory/dev/stacks
Otras variables...

## Uso del Makefile
Este proyecto utiliza un Makefile para automatizar la creación y gestión de los recursos AWS necesarios. Consulta la sección anterior para conocer los comandos disponibles y cómo utilizarlos.

## Implementación
Revisa los comandos que puedes usar para implementar tu aplicación en AWS ECS Fargate.

--------
```console
Target                     Help                                                        Usage
------                     ----                                                        -----
network.create          Create stack for all network(vpc, subnets,etc.)             make network.create
network.delete          Delete stack network                                        make network.delete
task.create             Create stack for task definition                            make task.create
task.delete             Delete stack task definition                                make task.delete
task.update             Update stack definition                                     make task.update
alb.create              Create stack for alb, targetgroup, listener                 make alb.create
alb.delete              Delete stack about alb                                      make alb.delete
service.create          Create stack ECS Fargate(cluster, service,etc)              make service.create
service.delete          Delete stack ECS Fargate                                    make service.delete

```

## Referencias
- https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/template-reference.html
- https://github.com/1Strategy/fargate-cloudformation-example/blob/master/fargate.yaml