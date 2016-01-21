require('./app.scss');
import React from 'react';
import ReactDOM from 'react-dom';
import $ from 'jquery';
import Lightbox from 'react-images';
import Gallery from './gallery';
import Loading from './loading';
import _ from 'lodash';

const FONT_COLORS = _.range(0, 10, 2).map(function(i){
  return `#${i}${i}${i}`;
});

const lightboxStyles  = Lightbox.extendStyles({
  backdrop: {
    backgroundColor: 'rgba(0,0,0,1)',
  },
  dialog:{
    maxHeight: '90%'
  }
});

module.exports = React.createClass({
  getInitialState: function() {
    return {
      photos: null,
      maxPhotos: 0,
      containerWidth: 0,
      loadSize: 0
    };
  },
  loop: function() {
    setTimeout(function(){
      $.get('/medias', function(images){
        this.setState({photos: images});
      }.bind(this));
      this.loop();
    }.bind(this), 3000);
  },
  componentWillMount: function() {
    window.addEventListener('scroll', this.handleScroll);
    this.loop();
  },
  calcState: function(containerWidth) {
    if (containerWidth >= 1024){
      return {loadSize: 3, containerWidth: containerWidth, maxPhotos: 12, fontSize: '35px'};
    } else if (containerWidth >= 480){
      return {loadSize: 2, containerWidth: containerWidth, maxPhotos: 6, fontSize: '20px'};
    } else {
      return {loadSize: 1, containerWidth: containerWidth, maxPhotos: 3, fontSize: '14px'};
    }
  },
  componentDidMount: function(){
    var containerWidth = Math.floor(ReactDOM.findDOMNode(this).clientWidth);
    this.setState(this.calcState(containerWidth));
    window.addEventListener('resize', this.handleResize);
  },

  handleResize: function(e){
    var containerWidth = ReactDOM.findDOMNode(this).clientWidth;
    if (ReactDOM.findDOMNode(this).clientWidth !== this.state.containerWidth){
      console.log(this.calcState(containerWidth));
      this.setState(this.calcState(containerWidth));
    }
  },
  handleScroll: function(e) {
    if ((window.innerHeight + window.scrollY) >= (document.body.offsetHeight - 120)) {
      this.loadMorePhotos();
    }
  },
  loadMorePhotos: function() {
    if(this.state.photos && this.state.photos.length > this.state.maxPhotos) {
      this.setState({maxPhotos: this.state.maxPhotos + this.state.loadSize});
    }
  },
  getPhotos: function() {
    var photos = _.filter(this.state.photos, {type: 'image'});
    return _.take(photos, this.state.maxPhotos);
  },
  renderTexts: function() {
    var texts = _.filter(this.state.photos, {type: 'text'});
    if(texts.length < 1) {
      return null;
    }
    return texts.map(function(txt, i){
      var color = FONT_COLORS[i] || '#999';
      return (
        <p key={i} style={{fontSize: this.state.fontSize, color: color}}>
          &nbsp;&nbsp; > {txt.text}
        </p>
      );
    }.bind(this));
  },
  render: function() {
    if(!this.state.photos) {
      return <Loading />;
    }
    
    return (
      <div>
        <Gallery photos={this.getPhotos()} lightboxStyles={lightboxStyles} />
        <div className="forum" >{this.renderTexts()}</div>
      </div>
    );
  }
});
