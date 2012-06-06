define (require, exports, module) ->
  module.exports = ->
    """
      <div class="wrapper">
        <ul>
          <li><a href="#{@host}"></a>Zooniverse</a></li>

          <li class="languages dropdown">
            <span>
              <span lang="en">EN</span>
            </span>
            <ul>
              <li><a href="#en">EN</a></li>
            </ul>
          </li>
        </ul>

        <ul>
          <li><a href="http://zooniverse.org/about">About</a></li>

          <li class="dropdown">
            <span>Projects</span>
            <ul>
              <li class="accordion">
                <span>Space</span>
                <ul>
                  <li><a href="https://www.zooniverse.org/project/hubble">Galaxy Zoo: Hubble</a></li>
                  <li><a href="https://www.zooniverse.org/project/moonzoo">Moon Zoo</a></li>
                  <li><a href="https://www.zooniverse.org/project/solarstormwatch">Solar Stormwatch</a></li>
                  <li><a href="https://www.zooniverse.org/project/mergers">Galaxy Zoo: Mergers</a></li>
                  <li><a href="https://www.zooniverse.org/project/supernovae">Galaxy Zoo: Supernovae</a></li>
                  <li><a href="https://www.zooniverse.org/project/planethunters">Planet Hunters</a></li>
                  <li><a href="https://www.zooniverse.org/project/milkyway">Milky Way Project</a></li>
                </ul>
              </li>

              <li class="accordion">
                <span>Climate</span>
                <ul>
                  <li><a href="https://www.zooniverse.org/project/oldweather">Old Weather</a></li>
                </ul>
              </li>

              <li class="accordion">
                <span>Humanities</span>
                <ul>
                  <li><a href="https://www.zooniverse.org/project/ancientlives">Ancient Lives</a></li>
                </ul>
              </li>

              <li class="accordion">
                <span>Nature</span>
                <ul>
                  <li><a href="https://www.zooniverse.org/project/whalefm">Whale FM</a></li>
                </ul>
              </li>
            </ul>
          </li>

          <li class="login dropdown">
            <span>
              <span class="sign-in">Sign in</span>
              <span class="username">Username</span>
            </span>
            <div></div>
          </li>
        </ul>
      </div>
    """
