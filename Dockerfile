FROM archlinux:latest
ENV TZ=Europe/London

RUN pacman -Syu --noconfirm
RUN pacman -S --noconfirm --needed uv bat btop neofetch xclip zip unzip 7zip git fzf tmux upx neovim stow ghostty jdk-openjdk python3 lldb curl wget zsh binwalk squashfs-tools

ENV VIRTUAL_ENV=/opt/headless
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

RUN uv venv /opt/headless --python 3.11
RUN source /opt/headless/bin/activate
RUN uv pip install ipython==8.32.0 jupyterlab numpy==1.23.5 matplotlib pandas pwntools angr angr-management z3-solver seaborn plotly scikit-learn bokeh==2.4.3 statsmodels scipy ropper keystone-engine ghidra_jupyter ipywidgets requests pandas_bokeh monkeyhex pyvex bingraphvis angr-utils cfg-explorer jupyter-black

WORKDIR /opt/src
RUN wget https://github.com/NationalSecurityAgency/ghidra/releases/download/Ghidra_11.3.1_build/ghidra_11.3.1_PUBLIC_20250219.zip
RUN unzip ./ghidra_11.3.1_PUBLIC_20250219.zip
ENV GHIDRA_INSTALL_DIR="/opt/src/ghidra_11.3.1_PUBLIC/"
RUN uv pip install pyghidra
RUN uv pip install --upgrade pip
RUN git clone https://github.com/mandiant/capa.git
WORKDIR /opt/src/capa
RUN git submodule update --init --recursive
RUN uv pip install -e .

WORKDIR /local
EXPOSE 8888
ENTRYPOINT ["jupyter-lab", "--ip=0.0.0.0","--allow-root"]
