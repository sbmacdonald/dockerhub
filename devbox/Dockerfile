FROM ubuntu:14.04

# Install dev environment
RUN apt-get update -y
RUN apt-get install -y git
RUN apt-get install -y python
RUN apt-get install -y curl
RUN apt-get install -y vim
RUN apt-get install -y strace
RUN apt-get install -y diffstat
RUN apt-get install -y pkg-config
RUN apt-get install -y cmake
RUN apt-get install -y build-essential
RUN apt-get install -y tcpdump
RUN apt-get install -y screen
RUN apt-get install -y python-pip
RUN apt-get install -y bash-completion

# Install docker client
RUN apt-get install apt-transport-https 
RUN apt-get install ca-certificates
RUN apt-key adv \
  --keyserver hkp://p80.pool.sks-keyservers.net:80 \
  --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
RUN echo "deb https://apt.dockerproject.org/repo ubuntu-trusty main" > /etc/apt/sources.list.d/docker.list
RUN apt-get update
RUN apt-get install docker

# Install c++ build deps for are-platform
RUN apt-get update && apt-get install -y \
  cmake \
  g++ \
  pkg-config \
  lcov \
  gcovr \
  libboost-dev \
  libboost-date-time-dev \
  libboost-regex-dev \
  libboost-signals-dev \
  libboost-thread-dev \
  libboost-filesystem-dev \
  libboost-test-dev \
  libssl-dev \
  libzmq3-dev \
  libevent-dev \
  libprotobuf-dev \
  protobuf-compiler \
  libyaml-cpp-dev \
  wget

# Install the julia and the julia protobuf plugin
RUN apt-get install -y software-properties-common
RUN apt-add-repository -y ppa:staticfloat/juliareleases
RUN apt-get update
RUN apt-get install -y julia
RUN julia -e 'Pkg.update(); Pkg.add("ProtoBuf")'

# Setup home environment
RUN useradd steve
RUN mkdir /home/steve && chown -R steve: /home/steve

# Copy the .julia from /root to /home/steve
RUN cp -R /root/.julia /home/steve/.julia

# Create a shared data volume
# We need to create an empty file, otherwise the volume will
# belong to root.
# This is probably a Docker bug.
RUN mkdir /var/shared/
RUN touch /var/shared/placeholder
RUN chown -R steve:steve /var/shared
VOLUME /var/shared

ENV PATH $PATH:/home/steve/.julia/v0.4/ProtoBuf/plugin

WORKDIR /home/steve
ENV HOME /home/steve
ADD bashrc /home/steve/.bashrc

# Add the git bash prompt
RUN git clone https://github.com/magicmonty/bash-git-prompt.git /home/steve/.bash-git-prompt --depth=1

# Add python virtualenvwrapper
RUN pip install virtualenvwrapper
RUN ln -s /usr/local/bin/virtualenvwrapper.sh /usr/bin/virtualenvwrapper.sh
RUN bash -c "source /usr/local/bin/virtualenvwrapper.sh"

# Link in shared parts of the home directory
RUN ln -s /var/shared/.vimrc /home/steve/.vimrc
RUN ln -s /var/shared/.vim /home/steve/.vim
RUN ln -s /var/shared/.gitconfig /home/steve/.gitconfig
RUN ln -s /var/shared/.ssh /home/steve/.ssh
RUN ln -s /var/shared/.bash_history /home/steve/.bash_history
RUN ln -s /var/shared/devel /home/steve/devel

# Pretty bash prompt
RUN echo 'export PS1="\[\033[36m\][\[\033[m\]\[\033[33m\]\u@\h\[\033[m\] \[\033[32m\]\W\[\033[m\]\[\033[36m\]]\[\033[m\] $ "' >> /home/steve/.bashrc

# Add in bash completion
RUN echo '\
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then\n\
    . /etc/bash_completion\n\
fi\n\
' >> /home/steve/.bashrc

RUN chown -R steve: /home/steve
USER steve