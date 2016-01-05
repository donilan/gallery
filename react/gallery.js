import React from 'react';
import $ from 'jquery';
import Gallery from 'react-photo-gallery';
import Lightbox from 'react-images';
import Loading from './loading';

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
    return {photos: null};
  },
  componentWillMount: function() {
    $.get('/images', function(images){
      this.setState({photos: images});
    }.bind(this));
  },
  render: function() {
    if(!this.state.photos) {
      return <Loading />;
    }
    return (
      <div>
        <Gallery photos={this.state.photos} lightboxStyles={lightboxStyles} />
      </div>
    );
  }
});
