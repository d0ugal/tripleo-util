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
sudo useradd heap;
echo "heap ALL=(root) NOPASSWD:ALL" | sudo tee -a /etc/sudoers.d/heap;
sudo chmod 0440 /etc/sudoers.d/heap;
su - heap;
```

As the heap user.

```
git clone https://github.com/d0ugal/tripleo-util.git;
~/tripleo-util/host/install.sh;
```

Then to connect to the undercloud...

```
~/tripleo-util/u.sh
```

## restack

```
~/tripleo-util/host/restack.sh;
```


## undercloud

```
git clone https://github.com/d0ugal/tripleo-util.git;
~/tripleo-util/undercloud/install.sh;
```
