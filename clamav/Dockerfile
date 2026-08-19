FROM debian:bookworm-slim

RUN apt-get update && \
    apt-get install --no-install-recommends -y \
        clamav-daemon \
        ca-certificates \
        gettext-base && rm -rf /var/lib/apt/lists/*
EXPOSE 3310
RUN rm -rf /var/log/clamav/* && \
    ln -s /dev/stdout /var/log/clamav/clamav.log && \
    rm -f /etc/clamav/clamd.conf

COPY conf.d/clamav.conf.template /etc/clamav/clamd.conf.template
COPY src/run.sh /usr/local/bin/run.sh
RUN chmod +x /usr/local/bin/run.sh

RUN chown clamav:clamav /var/lib/clamav

ENV CLAMD_LISTENING_PORT=3310
USER clamav
# freshclam と共有する volume。ECS は空 volume 作成時に VOLUME 宣言パスの所有権を
# 引き継ぐため、clamav パッケージが両イメージで同一 uid/gid(100:102) を割り当てる
# ことで起動順によらず所有権が揃う
VOLUME ["/var/lib/clamav"]
# read-only root filesystem 対応: 設定生成と clamd 起動は run.sh 内で行う
CMD ["run.sh"]