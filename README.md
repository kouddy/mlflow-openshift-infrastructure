# mlflow-tracking-server-openshift-infrastructure

## Introduction
This repository contains MLflow's [tracking server](https://www.mlflow.org/docs/latest/tracking.html) Dockerfile as well as infrastructure-as-code needed to run on OpenShift.

## Quick start
### Trying it out locally
The fastest way to try it out is by start a container locally.
You can build container first by running:
```
docker build .
```

You can then start the container by running:
```
docker run -it -p 5000:5000 \
    -e BACKEND_STORE_URI="/app/mlflow/mlruns" \
    <container image ID>
```

Note that if file store is used, MLflow won't be able to use Artifact Store, so functionality such as uploading artifact and Model Registry will be disabled.
        
### Running it on OpenShift for production use case
After running `docker build .` and image it pushed to an place which stores Docker Image such as Docker Hub, you can use following command to do deployment:
```
oc process -f deployment.yaml \
    -p IMAGE_URL=<image URL> \
    -p BACKEND_STORE_URI=mysql://user:password@mysql:3306/sampledb \
    -p DEFAULT_ARTIFACT_ROOT="s3://<your bucket>/artifacts" \
    -p AWS_ACCESS_KEY_ID=<key> \
    -p AWS_SECRET_ACCESS_KEY=<password> \
    | oc apply -f-
```
Note that because now MLflow tracking server is deployed remotely (and usually is used in production), it is good to use non file store as backend store.
Also it is good to use AWS S3, or Azure, or Google Cloud to store artifacts when used in production.
Note that dependencies such as backend store such as a database and artifact store such as AWS S3 needs to be set explicitly before running above command.