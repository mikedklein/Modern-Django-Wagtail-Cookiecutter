// based on https://gist.github.com/paulirish/12fb951a8b893a454b32

const $ = document.querySelector.bind(document);
const $$ = document.querySelectorAll.bind(document);

// Not sure this is the best solution but we are extendingt the global dom interfaces
declare global {
  interface Window {
      on:(name: any, fn: any) => void;
  }
  interface Node {
    on:(name: any, fn: any) => void;
  }
  interface NodeList {
    addEventListener: (name: any, fn: any) => void;
    on:(name: any, fn: any) => void;
    __proto__: any[];
  }
}

Node.prototype.on = window.on = function (name: string, fn: Function) {
  this.addEventListener(name, fn);
};

NodeList.prototype.__proto__ = Array.prototype; // eslint-disable-line

NodeList.prototype.on = NodeList.prototype.addEventListener = function (name: string, fn: Function) {
  this.forEach((elem: HTMLElement) => {
    elem.on(name, fn);
  });
};

export { $, $$ };