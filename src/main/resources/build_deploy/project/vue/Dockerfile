# 设置基础镜像
FROM nginx:1.24.0

# 配置路由
RUN sed  -i  '/location \/ {/a\        try_files $uri $uri\/ \/index\.html;'   /etc/nginx/conf.d/default.conf

#这条命令是在Dockerfile或shell脚本中使用的，用于修改Nginx的配置文件/etc/nginx/conf.d/default.conf。具体来说，它使用sed命令（流编辑器）来自动化编辑文本文件。命令的作用分解如下：
#RUN：这是Dockerfile中的一个指令，用于在构建镜像的过程中执行命令。
#sed：是流编辑器，用于对文本进行过滤和转换。
#-i：这个选项告诉sed直接修改文件内容，而不是输出到标准输出（终端或其他文件）。
#'/location \/ {/a\ try_files $uri $uri\/ \/index\.html;'：这是sed的命令部分，具体分解如下：
#/location \/ {/：寻找文件中匹配location / {的行。这里的\/是对斜杠/的转义，因为斜杠在sed命令中有特殊意义。
#a\：a命令用于在匹配行之后追加文本。\是为了续行，表示追加的内容在下一行开始。
#try_files $uri $uri\/ \/index\.html;：这是要追加到找到的location / {行后面的Nginx配置指令。它告诉Nginx先尝试提供请求的URI对应的文件，如果找不到，尝试作为目录处理（$uri/），如果这都不行，最后尝试提供/index.html文件。这条指令通常用于单页应用（SPA），确保应用的路由可以正确处理。
#综上，这条命令的作用是在Nginx的默认配置文件中找到第一个出现的location / {块，并在其后追加try_files $uri $uri/ /index.html;配置。这样配置后，Nginx会尝试按照try_files指令提供文件，这对于前端路由非常有用，特别是在使用Vue、React这类JavaScript框架开发的单页应用中。

# 删除默认nginx欢迎页
RUN rm /usr/share/nginx/html/index.html

# 上传页面文件
COPY gxtsweb/  /usr/share/nginx/html/gxtsweb



