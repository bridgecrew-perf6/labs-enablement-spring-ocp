==2 hours==
mvn  -DskipTests clean package
cp target/*.jar dist/app.jar
java -jar dist/app.jar
-------
oc new-project dev-apps
cat Dockerfile | oc new-build -D - --name springbootapp
oc start-build springbootapp --from-dir ./dist --follow  
oc new-app --name springbootapp springbootapp -l app=springbootapp
oc get pods -l deployment=springbootapp
oc label dc springbootapp app=springbootapp
oc new-app  --name springbootapp-2 springbootapp -e spring.application.name=test
oc set env dc/springbootapp spring.application.name=springboot3
##Service to service communication
0. App metrics via ocp console
  -> get pod status. talk about probes.
  -> 
1. Create a service for the app
   > oc create service 
    oc create service clusterip springbootapp -o yaml --dry-run=client --tcp=8080:8080 \
    | oc set selector --local -f - 'deployment=springbootapp' -o yaml | oc create -f -
    | curl springbootapp:8080/appname
2. Use the url to curl from springboot3
    | curl springbootapp.dev-apps.svc.cluster.local:8080/appname
3. Port-forwarding for local test
    | oc port-forward pod/springbootapp-67c6c7b9b6-cs4wg 9000:8080
    | oc port-forward svc/springbootapp 9000:8080
    | kubectl - k8s native client
#access service external access
4. Create route to access the app outside the cluster -
# Give info k8s service discovery
# Openshift annotations on topology
# Labels
    | oc expose svc/springbootapp
#### Config management
1. oc new-app  --name springbootapp-2 springbootapp -e spring.application.name=test
2. config map - 
    oc create configmap springbootapp-config \
    --from-literal=spring.application.name=config-map-app \
    --from-literal=anotherproperty=helloworld
3. Attach config map to a deployment
    | oc new-app  --name springbootapp-configmap-example springbootapp
    | oc set env --from=configmap/springbootapp-config deployment/springbootapp-configmap-example
4. Attach secret  - 
 |oc create secret generic my-secret --from-literal=key1=supersecret --from-literal=key2=topsecret
 |oc set env --from=secret/my-secret deployment/springbootapp-configmap-example

5. Scaling
    oc scale deployments/springbootapp-configmap-example --replicas 2
    oc autoscale deployments/springbootapp-configmap-example --min 2 --max 5 --cpu-percent=75 #hpa
    vpa for stateful apps
5. Adhoc tasks - Spring cloud task
6. Jobs and cronjobs - Spring batch
   #TODO
-----------
##
==Cluster part
oc get projects/dev-apps -o yaml > project.yaml
===deployment descriptors
1. Pod, Deployment, deploymentconfig, service route etc., 
##App Part
oc get deployment/springbootapp -o yaml > deployment.yaml
oc get routes/springbootapp -o yaml > route.yaml
oc get svc/springbootapp -o yaml > service.yaml
##config Part
oc get secrets/my-secret -o yaml >secret.yaml
oc get configmap/springbootapp-config -o yaml  > configmap.yaml



=====
Intro
=====
----
#with config
 mvn -DskipTests package
 java -jar dist/app.jar --spring.application.name=test
-------



