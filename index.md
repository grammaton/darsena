---
title: Darsena
layout: home
last_modified_date: 2025-02-04 11:41:00 CET
nav_order: 1
---

{: .glossario }
{{ site.data.glossario.darsena }}

## approdo sicuro

```
git clone --recurse-submodules https://github.com/grammaton/darsena.git
```

Alcuni `submodules` sono privati, può accedere solamente chi può accedere.

## armatore

Per creare una nuova nave dell'arsenale [parti da qui], poi aggiungi il nuovo
elemento come `submodule` in `arsenale`.

## to do list

1. librerie SEAM
2. faust.ide
3. latex
4. test hub pubblico/privato
5. scan biblioteca
6. gestione catalogo
7. font alegreya
8. pagina glossario

----

{% include git-info.html %}

#### Vuoi contribuire? [E allora daje](https://github.com/grammaton/darsena)!

<ul class="list-style-none">
{% for contributor in site.github.contributors %}
  <li class="d-inline-block mr-1">
     <a href="{{ contributor.html_url }}"><img src="{{ contributor.avatar_url }}" width="64" height="64" alt="{{ contributor.login }}"></a>
  </li>
{% endfor %}
</ul>

[^1]: [It can take up to 10 minutes for changes to your site to publish after you push the changes to GitHub](https://docs.github.com/en/pages/setting-up-a-github-pages-site-with-jekyll/creating-a-github-pages-site-with-jekyll#creating-your-site).
[parti da qui]: https://github.com/grammaton/bucintoro/generate
