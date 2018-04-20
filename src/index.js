import './main.css';
import { Main } from './Main.elm';
import charactersPath from './graphics/characters.gif';
import registerServiceWorker from './registerServiceWorker';

Main.embed(document.getElementById('root'), {charactersPath: charactersPath});

registerServiceWorker();
