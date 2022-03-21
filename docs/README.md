<div id="top"></div>

<!-- PROJECT SHIELDS -->
<!--
*** I'm using markdown "reference style" links for readability.
*** Reference links are enclosed in brackets [ ] instead of parentheses ( ).
*** See the bottom of this document for the declaration of the reference variables
*** for contributors-url, forks-url, etc. This is an optional, concise syntax you may use.
*** https://www.markdownguide.org/basic-syntax/#reference-style-links
-->

<!-- PROJECT LOGO -->
<br />
<div align="center">
  <a href="https://github.com/Jaggernaute/PowaBonk">
    <img src="blobs/logo.png" alt="Logo" height="80">
  </a>

<h3 align="center">Powa Bonk</h3>

  <p align="center">
    Systeme de reservation de borne de recharge pour voiture electriques.
    <br />
    <a href="https://github.com/Jaggernaute/PowaBonk"><strong>Documentation »</strong></a>
    <br />
    <br />
    <a href="https://github.com/Jaggernaute/PowaBonk">Demo</a>
    ·
    <a href="https://github.com/Jaggernaute/PowaBonk/issues">Rapporter un bug</a>
    ·
    <a href="https://github.com/Jaggernaute/PowaBonk/issues">Demander un changement</a>
  </p>
</div>



<!-- TABLE OF CONTENTS -->
<details>
  <summary>Sommaire :</summary>
  <ol>
    <li>
      <a href="#about-the-project">A propos du projet</a>
      <ul>
        <li><a href="#built-with">Technologies utilisées</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Pour commencer</a>
      <ul>
        <li><a href="#prerequisites">Prerequis</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#usage">Utilisation</a></li>
    <li><a href="#roadmap">Roadmap</a></li>
    <li><a href="#contributing">Contribuer</a></li>
    <li><a href="#license">Licence</a></li>
    <li><a href="#contact">Contact</a></li>
    <li><a href="#acknowledgments">Remerciements</a></li>
  </ol>
</details>



<!-- ABOUT THE PROJECT -->
## A propos du projet

<img src="blobs/fullscreen-app.png" alt="Logo" height="300">




### Technologies utilisées

* [Qt](https://www.qt.io)
* [CMake](https://cmake.org)
* [ninja](https://ninja-build.org/manual.html#_introduction)
* [gcc](https://gcc.gnu.org)





<!-- GETTING STARTED -->
## Pour commencer

Pour compiler l'application depuis le code source il vous suffit de 
suivre les instructions ci-dessous.

### Prerequis

Liste des prerequis pour et instructions simple pour les installer 
(vous trouverez des instructions plus detailées sur le site officiel).

#### Linux
#### Arch Linux:
  ```sh
  pacman -S qt6-base-git
  ```
  [Pour en savoir plus](https://wiki.archlinux.org/title/qt) 

#### Debian/Ubuntu:
  ```sh
  sudo apt-get build-dep qtbase5-dev libxcb
  sudo apt-get install cmake ninja-build clang build-essential libb2-dev libzstd-dev \
    libsystemd-dev libhunspell-dev libclang-10-dev libmng-dev \
    libwebp-dev libdouble-conversion-dev libkrb5-dev libdirectfb-dev libts-dev \
    libproxy-dev libsctp-dev libbrotli-dev
    
  cd ~/Downloads
  wget -c https://download.qt.io/official_releases/qt/6.1/6.1.0/single/qt-everywhere-src-6.1.0.tar.xz
  tar -xf qt-everywhere-src-6.1.0.tar.xz
    
  cd qt-everywhere-src-6.1.0
  ./configure
  cmake --build . --parallel
  ```
[Pour en savoir plus](https://wiki.debian.org/qt)  
[pourquoi c'est si compliqué](https://askubuntu.com/a/1341877)
### Installation

1. Clonez le repository sur votre machine.
   ```sh
   git clone https://github.com/Jaggernaute/PowaBonk.git
   ```
2. Dans le dossier `PowaBonk`, executez la commande suivante:
   ```sh
   cmake CmakeLists.txt
   ```
3. Compilez l'application avec la commande suivante:
   ```js
   make
   ```




<!-- USAGE EXAMPLES -->
## Usage

Use this space to show useful examples of how a project can be used. 
Additional screenshots, code examples and demos work well in this space. 
You may also link to more resources.

_For more examples, please refer to the [Documentation](https://example.com)_




<!-- ROADMAP -->
## Roadmap

- [ ] Feature 1
- [ ] Feature 2
- [ ] Feature 3
    - [ ] Nested Feature

See the [open issues](https://github.com/Jaggernaute/PowaBonk/issues) for a full list of proposed features (and known issues).




<!-- CONTRIBUTING -->
## Contributing

Before contributing code, please read the :

1. please respect the architecture of the project :
    ```
    .
    |--include
    |--libs
    |--ressources
    |  |--css
    |  |--images
    |  `--.env
    |--src
    `--tests
    ```
2. respect the cpp [style guide](https://google.github.io/styleguide/cppguide.html)
3. try to avoid CLang tidy warnings.
4. try to avoid using Qt's non-standard features.
5. use c++23 or higher(when it'll be released).
6. document your code with docstrings.
7. use the [CMake](https://cmake.org) build system.
8. do not push build files to the repository.
9. do not push code to the master branch, but to a branch named after the features you're adding.


<!-- LICENSE -->
## License

Distributed under the MIT License. See `LICENSE.txt` for more information.




<!-- CONTACT -->
## Contact

Your Name - [@twitter_handle](https://twitter.com/twitter_handle) -  contact@jaggernaute.com@ .com

Project Link: [https://github.com/Jaggernaute/PowaBonk](https://github.com/Jaggernaute/PowaBonk)




<!-- ACKNOWLEDGMENTS -->
## Acknowledgments

* []()
* []()
* []()




<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[contributors-shield]: https://img.shields.io/github/contributors/Jaggernaute/PowaBonk.svg?style=for-the-badge
[contributors-url]: https://github.com/Jaggernaute/PowaBonk/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/Jaggernaute/PowaBonk.svg?style=for-the-badge
[forks-url]: https://github.com/Jaggernaute/PowaBonk/network/members
[stars-shield]: https://img.shields.io/github/stars/Jaggernaute/PowaBonk.svg?style=for-the-badge
[stars-url]: https://github.com/Jaggernaute/PowaBonk/stargazers
[issues-shield]: https://img.shields.io/github/issues/Jaggernaute/PowaBonk.svg?style=for-the-badge
[issues-url]: https://github.com/Jaggernaute/PowaBonk/issues
[license-shield]: https://img.shields.io/github/license/Jaggernaute/PowaBonk.svg?style=for-the-badge
[license-url]: https://github.com/Jaggernaute/PowaBonk/blob/master/LICENSE.txt
[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&colorB=555
[linkedin-url]: https://linkedin.com/in/ 
[product-screenshot]: images/screenshot.png