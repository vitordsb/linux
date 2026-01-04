## Instalando minhas configs nessa budega de linux

algumas coisas que preciso lembrar pra eu não me complicar
Por exemplo esse comando git para eu ter que por apenas uma vez a minha senha TOKEN do github:

```shell 
git config --global credential.helper store
```
OBS: tem que ter o git instalado, se não você não me ajuda

Se eu quiser instalar o neovim atualizado ao inves de ficar batendo cabeça é só eu digitar isso no terminal

```shell
git clone https://github.com/vitordsb/my-linux.git
cd my-linux
./install.sh
```
e escolher a opção numero do neovim que eu quero instalar
OBS: se o comando não funcionar é por que a anta aqui esqueceu de atualizar o repo. Acesse meu perfil no github e pega la pelo menos o arquivo de instalação do neovim.sh

pra node, php e outras budegas vai para o proximo arquivo de instalação de tecnologias
