# Install Zsh and Oh-My-ZSH

## Step 1: Installation of Zsh

### MacOS High Sierra

If brew is installed

```Shell
brew install zsh
```

Else

```Shell
sudo port install zsh zsh-completions
```

### Ubuntu, Debian & derivatives (Windows 10 WSL | Native Linux kernel with Windows 10 build 1903)

```Shell
apt install zsh
```

### Centos/RHEL

```Shell
sudo yum update && sudo yum -y install zsh
```

### Fedora

```Shell
dnf install zsh
```

## Step 2: Setup Zsh as default shell

### To set zsh as your default shell, execute the following for macOS High Sierra

```Shell
chsh -s /bin/zsh
```

## Step 3: Install Oh-My-Zsh

## Getting Started

### Prerequisites

- A Unix-like operating system: macOS, Linux, BSD. On Windows: WSL is preferred, but cygwin or msys also mostly work.
- [Zsh](https://www.zsh.org) should be installed (v4.3.9 or more recent). If not pre-installed (run `zsh --version` to confirm), check the following instructions here: [Installing ZSH](https://github.com/ohmyzsh/ohmyzsh/wiki/Installing-ZSH)
- `curl` or `wget` should be installed
- `git` should be installed (recommended v1.7.2 or higher)

### Basic Installation

Oh My Zsh is installed by running one of the following commands in your terminal. You can install this via the command-line with either `curl` or `wget`.

#### via curl

```shell
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

#### via wget

```shell
sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

#### Manual inspection

It's a good idea to inspect the install script from projects you don't yet know. You can do
that by downloading the install script first, looking through it so everything looks normal,
then running it:

```shell
curl -Lo install.sh https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh
sh install.sh
```

## Step 4: Using Oh My Zsh

### Plugins

Oh My Zsh comes with a shitload of plugins to take advantage of. You can take a look in the [plugins](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins) directory and/or the [wiki](https://github.com/ohmyzsh/ohmyzsh/wiki/Plugins) to see what's currently available.

#### Enabling Plugins

Once you spot a plugin (or several) that you'd like to use with Oh My Zsh, you'll need to enable them in the `.zshrc` file. You'll find the zshrc file in your `$HOME` directory. Open it with your favorite text editor and you'll see a spot to list all the plugins you want to load.

```shell
vi ~/.zshrc
```

For example, this might begin to look like this:

```shell
plugins=(
  git
  bundler
  dotenv
  osx
  rake
  rbenv
  ruby
)
```

_Note that the plugins are separated by whitespace. **Do not** use commas between them._

#### Using Plugins

Most plugins (should! we're working on this) include a **README**, which documents how to use them.

### Themes

We'll admit it. Early in the Oh My Zsh world, we may have gotten a bit too theme happy. We have over one hundred themes now bundled. Most of them have [screenshots](https://github.com/ohmyzsh/ohmyzsh/wiki/Themes) on the wiki. Check them out!

#### Selecting a Theme

_Robby's theme is the default one. It's not the fanciest one. It's not the simplest one. It's just the right one (for him)._

Once you find a theme that you'd like to use, you will need to edit the `~/.zshrc` file. You'll see an environment variable (all caps) in there that looks like:

```shell
ZSH_THEME="robbyrussell"
```

## Bonus Plugins and zsh plugin config

### Zsh-Autosuggestions

```Shell
git clone https://github.com/zsh-users/zsh-autosuggestions.git ~/.oh-my-zsh/plugins/zsh-autosuggestions
```

### Zsh-syntax-highlighting

```Shell
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/plugins/zsh-syntax-highlighting
```

Once you spot a plugin (or several) that you'd like to use with Oh My Zsh, you'll need to enable them in the `.zshrc` file. You'll find the zshrc file in your `$HOME` directory. Open it with your favorite text editor and you'll see a spot to list all the plugins you want to load.

```shell
vi ~/.zshrc
```

For example, this might begin to look like this:

```shell
plugins=(
  git
  aws
  docker
  docker-compose
  sudo
  zsh-autosuggestions
  zsh-syntax-highlighting
  zsh-navigation-tools
)
```

### Set a Theme

First we will download the [dipadityadas.zsh-theme](https://github.com/DipadityaDas/InstallZsh/blob/main/dipadityadas.zsh-theme).

```shell
cp dipadityadas.zsh-theme ~/.oh-my-zsh/theme/
```

After that we will update the `ZSH_THEME` option in `.zshrc` file.

```shell
ZSH_THEME="dipadityadas"
```

Lastly, we will execute the zsh again, in order to load our theme.

```shell
source ~/.zshrc
```

![Result](https://github.com/DipadityaDas/InstallZsh/raw/main/img/result.png)

---
## Author: `Dipaditya Das | DipadityaDas@gmail.com`
---