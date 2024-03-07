germainDbHostname="test-db"
germainEnvName=germain-qa

elasticSearchVersion="8.8.1"
mysqlVersion="8"
kibanaVersion="8.8.1"
activeMqVersion="5.18.3"
zookeeperVersion="3.6.3"
hazelcastVersion="5.2.2-SNAPSHOT"
kafkaVersion="3.4"
germainVersion=2023.3
germainApmBuildRegistry=public.ecr.aws/h0m9e4y5
germainEnvName=germain-demo

mysqlReplicas=1
elasticSearchReplicas=2
kibanaReplicas=1
activeMqReplicas=1
zookeeperReplicas=1
hazelcastReplicas=1
kafkaReplicas=0
germainServerReplicas=1
germainStorageReplicas=1
germainRtmReplicas=1
germainSessionReplicas=1
germainAnalyticsReplicas=1
germainAggregationReplicas=1
germainActionReplicas=1

mysqlRootPassword="germain-db"

#############################################################################################################################
# GENERATE DEPLOYMENT MANIFESTS
#############################################################################################################################

# Initialize install directory
rm -rf ./${germainEnvName}/
mkdir ./${germainEnvName}
mkdir ./${germainEnvName}/configmap
cp -r ./templates/* ./${germainEnvName}/

# Database
sed -i "s|{{germain-external-db}}|${germainDbHostname}|g" ./${germainEnvName}/infra/infra-db.yaml

# Elastic
sed -i "s|{{elasticSearchVersion}}|${elasticSearchVersion}|g" ./${germainEnvName}/infra/infra-es.yaml
sed -i "s|{{elasticSearchReplicas}}|${elasticSearchReplicas}|g" ./${germainEnvName}/infra/infra-es.yaml

# MySQL
sed -i "s|{{mysqlVersion}}|${mysqlVersion}|g" ./${germainEnvName}/infra/infra-mysql.yaml
sed -i "s|{{mysqlReplicas}}|${mysqlReplicas}|g" ./${germainEnvName}/infra/infra-mysql.yaml
sed -i "s|{{mysqlRootPassword}}|${mysqlRootPassword}|g" ./${germainEnvName}/infra/infra-mysql.yaml

# Kibana
sed -i "s|{{kibanaVersion}}|${kibanaVersion}|g" ./${germainEnvName}/infra/infra-kibana.yaml
sed -i "s|{{kibanaReplicas}}|${kibanaReplicas}|g" ./${germainEnvName}/infra/infra-kibana.yaml

# Zookeeper
sed -i "s|{{zookeeperVersion}}|${zookeeperVersion}|g" ./${germainEnvName}/infra/infra-zookeeper.yaml
sed -i "s|{{zookeeperReplicas}}|${zookeeperReplicas}|g" ./${germainEnvName}/infra/infra-zookeeper.yaml

# ActiveMQ
sed -i "s|{{activeMqVersion}}|${activeMqVersion}|g" ./${germainEnvName}/infra/infra-activemq.yaml
sed -i "s|{{activeMqReplicas}}|${activeMqReplicas}|g" ./${germainEnvName}/infra/infra-activemq.yaml

# Hazelcast
sed -i "s|{{hazelcastVersion}}|${hazelcastVersion}|g" ./${germainEnvName}/infra/infra-hazelcast.yaml
sed -i "s|{{hazelcastReplicas}}|${hazelcastReplicas}|g" ./${germainEnvName}/infra/infra-hazelcast.yaml
sed -i "s|{{germainVersion}}|${germainVersion}|g" ./${germainEnvName}/infra/infra-hazelcast.yaml

# Kafka
sed -i "s|{{kafkaVersion}}|${kafkaVersion}|g" ./${germainEnvName}/infra/infra-kafka.yaml
sed -i "s|{{kafkaReplicas}}|${kafkaReplicas}|g" ./${germainEnvName}/infra/infra-kafka.yaml

# Application
sed -i "s|{{germainVersion}}|${germainVersion}|g" ./${germainEnvName}/germain/germain.yaml
sed -i "s|{{germainApmBuildRegistry}}|${germainApmBuildRegistry}|g" ./${germainEnvName}/germain/germain.yaml
sed -i "s|{{germainServerReplicas}}|${germainServerReplicas}|g" ./${germainEnvName}/germain/germain.yaml
sed -i "s|{{germainStorageReplicas}}|${germainStorageReplicas}|g" ./${germainEnvName}/germain/germain.yaml
sed -i "s|{{germainRtmReplicas}}|${germainRtmReplicas}|g" ./${germainEnvName}/germain/germain.yaml
sed -i "s|{{germainSessionReplicas}}|${germainSessionReplicas}|g" ./${germainEnvName}/germain/germain.yaml
sed -i "s|{{germainAnalyticsReplicas}}|${germainAnalyticsReplicas}|g" ./${germainEnvName}/germain/germain.yaml
sed -i "s|{{germainAggregationReplicas}}|${germainAggregationReplicas}|g" ./${germainEnvName}/germain/germain.yaml
sed -i "s|{{germainActionReplicas}}|${germainActionReplicas}|g" ./${germainEnvName}/germain/germain.yaml

# ConfigMap
kubectl create configmap --dry-run=client activemq-xml --from-file=configData=./${germainEnvName}/config/activemq.xml --output yaml | tee ./${germainEnvName}/configmap/configmap-activemq-xml.yaml 2>/dev/null
kubectl create configmap --dry-run=client activemq-env --from-file=configData=./${germainEnvName}/config/activemq.env --output yaml | tee ./${germainEnvName}/configmap/configmap-activemq-env.yaml 2>/dev/null
kubectl create configmap --dry-run=client activemq-jetty-xml --from-file=configData=./${germainEnvName}/config/activemq-jetty.xml --output yaml | tee ./${germainEnvName}/configmap/configmap-activemq-jetty.yaml 2>/dev/null
kubectl create configmap --dry-run=client common-properties --from-file=configData=./${germainEnvName}/config/common.properties --output yaml | tee ./${germainEnvName}/configmap/configmap-common-properties.yaml 2>/dev/null
kubectl create configmap --dry-run=client start-zookeeper --from-file=configData=./${germainEnvName}/config/start-zookeeper --output yaml | tee ./${germainEnvName}/configmap/configmap-start-zookeeper.yaml 2>/dev/null
kubectl create configmap --dry-run=client zookeeper-ready --from-file=configData=./${germainEnvName}/config/zookeeper-ready --output yaml | tee ./${germainEnvName}/configmap/configmap-zookeeper-ready.yaml 2>/dev/null
kubectl create configmap --dry-run=client license-folder --from-file=./${germainEnvName}/config/license/ --output yaml | tee ./${germainEnvName}/configmap/configmap-license-folder.yaml 2>/dev/null
kubectl create configmap --dry-run=client apm-rtm-model --from-file=configData=./${germainEnvName}/config/apm-rtm-model.jar --output yaml | tee ./${germainEnvName}/configmap/apm-rtm-model.yaml 2>/dev/null

# Cleanup config files
rm -rf ./${germainEnvName}/config

#############################################################################################################################
# CONFIGMAP DEPLOYMENT
#############################################################################################################################
echo "Deploying configmap..."
kubectl apply -f ./${germainEnvName}/configmap/configmap-activemq-xml.yaml -f ./${germainEnvName}/configmap/configmap-activemq-env.yaml -f ./${germainEnvName}/configmap/configmap-activemq-jetty.yaml -f ./${germainEnvName}/configmap/configmap-common-properties.yaml -f ./${germainEnvName}/configmap/configmap-start-zookeeper.yaml -f ./${germainEnvName}/configmap/configmap-zookeeper-ready.yaml -f ./${germainEnvName}/configmap/configmap-license-folder.yaml -f ./${germainEnvName}/configmap/apm-rtm-model.yaml
echo "Deploying configmap completed"
#############################################################################################################################
# INFRA DEPLOYMENT
#############################################################################################################################
echo "Deploying infra..."
kubectl apply -f ./${germainEnvName}/infra/storage-class.yaml -f ./${germainEnvName}/infra/infra-zookeeper.yaml -f ./${germainEnvName}/infra/infra-activemq.yaml -f ./${germainEnvName}/infra/infra-db.yaml -f ./${germainEnvName}/infra/infra-es.yaml -f ./${germainEnvName}/infra/infra-kibana.yaml -f ./${germainEnvName}/infra/infra-hazelcast.yaml -f ./${germainEnvName}/infra/infra-mysql.yaml
echo "Deploying infra completed"
#############################################################################################################################
# APPLICATION DEPLOYMENT
#############################################################################################################################
echo "Deploying application..."
kubectl apply -f ./${germainEnvName}/germain/germain.yaml -f ./${germainEnvName}/germain/germain-services.yaml
echo "Deploying application completed"

#############################################################################################################################
# GET ADDRESS OF WORKSPACE
#############################################################################################################################

# Check creation status
germainUrl=`kubectl get svc server-lb -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'`
while [[ ${germainUrl} = "" || ${germainUrl} = "None" ]]
do
	echo "Waiting for public URL to be ready..."
	germainUrl=`kubectl get svc server-lb -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'`
	sleep ${sleepTime}
done

echo "Germain public URL:" ${germainUrl}

################################################################################################################