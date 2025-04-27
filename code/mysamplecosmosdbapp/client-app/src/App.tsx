import * as React from 'react';
import { useState } from 'react'
import 'bootstrap/dist/css/bootstrap.min.css';
import './App.css'
import { Routes, Route } from 'react-router';

import Container from 'react-bootstrap/Container';
import Row from 'react-bootstrap/Row';
import Col from 'react-bootstrap/Col';

import { MenuBar } from './menubar'; // Import the MenuBar component
import { Home } from './pages/home'; // Import the Home component
import { Brand } from './pages/brand'; // Import the Brand component
import { Categories } from './pages/categories';
import { Details } from './pages/details';

function App() {
  const [] = useState(0)

  return (
    <>
    <Container>
    <Row>
      <Col md={12} className="bg-light text-center">
        <MenuBar></MenuBar>
      </Col>
    </Row>
    <Row>
      <Routes>
        <Route path="/" element={<Home />} />
        <Route path="/brand/:brand" element={<Brand />} />
        <Route path="/categories/:category/" element={<Categories />} />
        <Route path="/categories/:category/:subcategory" element={<Categories />} />
        <Route path='/item/:category/:id' element={<Details />} />
      </Routes>
    </Row>
    </Container>
    </>
  )
}

export default App
