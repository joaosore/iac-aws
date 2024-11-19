# Cria um VPC da Aplicação
module "vpc" {
  source     = "./modules/vpc"
  cidr_block = "10.0.0.0/16"
  vpc_name   = "enviohub-vpc"
}

# Cria 4 subnet sendo 2 Publicas e 2 Privadas
module "subnet" {
  source                   = "./modules/subnet"
  vpc_id                   = module.vpc.vpc_id
  public_subnet_cidrs      = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs     = ["10.0.50.0/24", "10.0.51.0/24"]
  availability_zones       = ["us-east-1a", "us-east-1b"]
  public_subnet_name       = "enviohub-public-subnet"
  private_subnet_name      = "enviohub-private-subnet"
}

# Cria um internet Gatway para internet
module "internet_gateway" {
  source   = "./modules/internet_gateway"
  vpc_id   = module.vpc.vpc_id
  igw_name = "enviohub-igw"
}

# Cria um tabela de rotas para internet
module "route_table" {
  source            = "./modules/route_table"
  vpc_id            = module.vpc.vpc_id
  igw_id            = module.internet_gateway.igw_id
  subnet_ids        = module.subnet.public_subnet_ids
  route_table_name  = "enviohub-public-route-table"
}

# Cria 2 Grupos de Segurança um publico e privado
module "security_group" {
  source   = "./modules/security_group"
  vpc_id   = module.vpc.vpc_id
  sg_name  = "ecs-security-group"
}

# Cria 2 Load Balance publico e privado
module "load_balancer" {
  source           = "./modules/load_balancer"
  subnets          = module.subnet.public_subnet_ids
  security_group_id_public = module.security_group.security_group_id_public
  security_group_id_private = module.security_group.security_group_id_private
  vpc_id           = module.vpc.vpc_id
}

######################################################
module "iam" {
  source = "./modules/iam"
}
######################################################

######################################################
module "aws_cloudwatch_log_group" {
  source = "./modules/aws_cloudwatch_log_group"
}
######################################################

# module "ecr" {
#   source  = "./modules/ecr"
#   ecr_names = ["ec2-auth-enviohub-services", "ec2-proxyreverse-enviohub-services"]
# }

module "autoscaling_group" {
  source              = "./modules/autoscaling_group"
  target_group_arn    = module.load_balancer.target_group_external_arn
  subnets             = module.subnet.public_subnet_ids
  ami_id              = var.ami_id
  instance_type       = var.instance_type
  security_group_ids  = [module.security_group.security_group_id_public]
  ecs_cluster_name    = module.ecs.cluster_name
}

module "ecs" {
  source                 = "./modules/ecs"
  cluster_name           = "ec2-enviohub-cluster"
  execution_role_arn     = module.iam.ecs_task_execution_role_arn
  subnets                = module.subnet.public_subnet_ids
  security_group         = module.security_group.security_group_id_public
  target_group_arn       = module.load_balancer.target_group_external_arn
  autoscaling_group_arn  = module.autoscaling_group.ecs_autoscaling_group_arn
  ec2_internal_ips       = module.autoscaling_group.ec2_internal_ips
}