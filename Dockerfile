FROM centos:centos7

# Base system stuffs
RUN yum install -y deltarpm sudo openssh iproute expect-devel; yum -y update; yum clean all
RUN yum -y install gcc zlib-devel bzip2 bzip2-devel readline-devel python-devel; yum clean all;

# Home comforts
RUN sudo yum -y install git wget vim tmux; yum clean all;

# Initial quickstart deps. This needs to be re-run on a fresh clone, but this
# should get us the most of the deps, assuming they don't change often.
RUN git clone https://github.com/openstack/tripleo-quickstart.git ~/tripleo-quickstart --depth 1\
    && bash ~/tripleo-quickstart/quickstart.sh --install-deps;

# heap, not quite the stack user, user creation and keys
RUN sudo useradd heap && \
    echo "heap ALL=(root) NOPASSWD:ALL" | sudo tee -a /etc/sudoers.d/heap && \
    sudo chmod 0440 /etc/sudoers.d/heap;
USER heap
WORKDIR /home/heap/
ENTRYPOINT /bin/tmux
