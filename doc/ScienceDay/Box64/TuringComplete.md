你需要通过Steam购买这款游戏，然后将相应的游戏文件放置在Box64的游戏目录中。该游戏有Linux版本，请确保下载的是Linux版本的游戏文件。

在此时Steam运行会错误，而游戏依赖于Steam通讯。我们需要使用一些魔法来让它正确运行。

**请确保你拥有该游戏！这只是为了解决它在rv上无法运行而已！！！**

在游戏目录下进行：

clone以下仓库：
```bash
git clone https://github.com/ZeDoCaixao/activate
```

然后运行以下命令：

```bash
cp activate/activate .
chmod +x activate
./activate
```

你将会看到一个新的`libsteam_api.so`文件被创建。

游戏的存档位于：
`~/.local/share/godot/app_userdata/Turing\ Complete/`

将该文件下所有文件复制到相同的目录下。
然后你可以通过以下命令运行游戏：

```bash
box64 ./Turing\ Complete.x86_64
```

建议从社区下个 riscv32 的 cpu 做演示？w