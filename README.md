# TripleO Utils

Some TripleO dev tools, you shouldn't use this unless you are called Dougal.

## Host

First. tmux.

```bash
sudo yum upgrade -y
sudo yum install -y tmux vim wget git
tmux
```

Then this.

```bash
sudo useradd stack;
echo "stack ALL=(root) NOPASSWD:ALL" | sudo tee -a /etc/sudoers.d/stack;
sudo chmod 0440 /etc/sudoers.d/stack;
su - stack;
```

As the stack user.

``
ssh-keygen -f ~/.ssh/id_rsa -t rsa -N ''
sudo sh -c 'cat /home/stack/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys'
``

Finally this.

```bash
wget https://raw.githubusercontent.com/openstack/tripleo-quickstart/master/quickstart.sh;
chmod +x quickstart.sh;
./quickstart.sh --install-deps;
./quickstart.sh --bootstrap -R master-tripleo-ci 127.0.0.2;
```

## restack

```
./quickstart.sh --bootstrap --teardown all -R master-tripleo-ci 127.0.0.2;
```
