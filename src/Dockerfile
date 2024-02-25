FROM ubuntu as binaries
WORKDIR  /binaries
COPY ./* ./
RUN chmod +x ./*

FROM ubuntu as dependencies
RUN apt update && apt upgrade -y && apt install -y curl jq vim git zsh sudo unzip make systemctl python3.10 python3-pip
ENV ZSH /oh-my-zsh
ENV ZSH_CUSTOM /oh-my-zsh

RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended && \
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
COPY --from=binaries /binaries/* /bin/

RUN /bin/docker-install.sh

CMD ["/bin/change-user.sh"]