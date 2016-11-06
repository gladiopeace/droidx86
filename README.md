how to run this container image

first we build the image
we navigate to the current dockerfile directory:
cd webdroid
docker build . -t webdroid:0.1 --no-cache
then we run the image:
docker run  -d --name webodroirdtest1 -p 6080:6080 -p 22:22 -p 5900:5900 -v /dev/kvm:/dev/kvm --privileged webodroid:0.1 
# droidx86
