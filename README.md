##A http/nginx frontend to CephFS in a container.

This docker container mounts a ceph filesystem and then exposes the mount via HTTP (nginx) for download and upload (PUT).

Tested on CoreOS on a 8 node Ceph cluster. Ceph setup based on https://github.com/ceph/ceph-docker

Build from Dockerfile:
    `docker build -t mbessler/cephfs-nginx .`
    
Run:

  `docker run -d --rm  --net host --volumes-from cephdata  --privileged  -v /lib/modules:/lib/modules -e CEPHFS=<CLUSTER>:/<VOLUME> mbessler/cephfs-nginx`
  
where <CLUSTER> is a comma separated list of hostnames/IPs, and <VOLUME> is a Ceph Volume.

For example:  `docker run -d --rm  --net host --volumes-from cephdata  --privileged  -v /lib/modules:/lib/modules -e CEPHFS=192.168.1.201,192.168.1.202,192.168.1.203,192.168.1.204,192.168.1.205:/ mbessler/cephfs-nginx`

Upload via
  `curl --upload dir/file_to_upload http://<SERVER>/some/directory/`
or
   `curl -X PUT --data-binary @dir/file_to_upload http://<SERVER>/some/directory/file_to_upload`
where <SERVER> is any IP/hostname in the Ceph cluster running this docker image.

Since nginx inside the container runs as user 'www-data', uploads require the appropriate directory on your Ceph volume to be writable by that user, eg:
  `docker exec -it <container> chown www-data /ceph/<dir>`

WARNING: As-is, this image does not limit uploads or downloads in any way, there is no authentication, intended to show concepts only.
         Do not use in production, do not expose to public networks.



