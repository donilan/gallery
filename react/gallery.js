import React from 'react';
import ReactDOM from 'react-dom';
import $ from 'jquery';
import Gallery from 'react-photo-gallery';
import Lightbox from 'react-images';
import Loading from './loading';
import _ from 'lodash';

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
      $.get('/images', function(images){
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
      return {loadSize: 3, containerWidth: containerWidth, maxPhotos: 9};
    } else if (containerWidth >= 480){
      return {loadSize: 2, containerWidth: containerWidth, maxPhotos: 6};
    } else {
      return {loadSize: 1, containerWidth: containerWidth, maxPhotos: 2};
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
    if ((window.innerHeight + window.scrollY) >= (document.body.offsetHeight - 50)) {
      this.loadMorePhotos();
    }
  },
  loadMorePhotos: function() {
    if(this.state.photos && this.state.photos.length > this.state.maxPhotos) {
      this.setState({maxPhotos: this.state.maxPhotos + this.state.loadSize});
    }
  },
  render: function() {
    if(!this.state.photos) {
      return <Loading />;
    }
    return (
      <div>
        <Gallery photos={_.take(this.state.photos, this.state.maxPhotos)} lightboxStyles={lightboxStyles} />
      </div>
    );
  }
});
