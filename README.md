## armatore

Per creare una nuova nave dell'arsenale [parti da qui], poi aggiungi il nuovo
elemento come `submodule` in `arsenale`.

```
cd arsenale
git submodule add http://github.com/...
```

per modificare direttamente l'artefatto dall'Arsenale

```
cd [submodule-folder]
git status
git add .
git commit -am "ciccio"
git pull
git push
```

----

[parti da qui]: https://github.com/grammaton/bucintoro/generate
