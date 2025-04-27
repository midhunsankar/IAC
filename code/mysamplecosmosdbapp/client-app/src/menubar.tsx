import * as React from 'react';
import Navbar from 'react-bootstrap/Navbar';
import NavDropdown from 'react-bootstrap/NavDropdown';
import Nav from 'react-bootstrap/Nav';

function MenuBar() {
    return (
        <>
            <Navbar expand="lg" className="bg-body-tertiary">
            <Navbar.Brand>My Bike Shop</Navbar.Brand>
                <Navbar.Toggle aria-controls="basic-navbar-nav" />
                <Navbar.Collapse id="basic-navbar-nav">
                <Nav className="me-auto">
                    <Nav.Link href="/">Home</Nav.Link>

                    <NavDropdown title="Categories" id="basic-nav-dropdown">
                        <NavDropdown.Item href="/categories/mountain">Mountain
                            <NavDropdown.Item href="/categories/mountain/hardtail">Hardtail</NavDropdown.Item>
                            <NavDropdown.Item href="/categories/mountain/trail">Trail</NavDropdown.Item>
                            <NavDropdown.Item href="/categories/mountain/enduro">Enduro</NavDropdown.Item>
                            <NavDropdown.Item href="/categories/mountain/cross country">Cross Country</NavDropdown.Item>
                        </NavDropdown.Item>
                        <NavDropdown.Item href="/categories/road">Road</NavDropdown.Item>
                        <NavDropdown.Item href="/categories/hybrid">Hybrid</NavDropdown.Item>
                        <NavDropdown.Item href="/categories/electric">Electric</NavDropdown.Item>
                        <NavDropdown.Item href="/categories/bmx">BMX</NavDropdown.Item>
                    </NavDropdown>
                    <NavDropdown title="Brands" id="basic-nav-dropdown">
                        <NavDropdown.Item href="/brand/trek">Trek</NavDropdown.Item>
                        <NavDropdown.Item href="/brand/cannondale">Cannondale</NavDropdown.Item>
                        <NavDropdown.Item href="/brand/giant">Giant</NavDropdown.Item>
                        <NavDropdown.Item href="/brand/haro">Haro</NavDropdown.Item>
                        <NavDropdown.Item href="/brand/santa cruz">Santa Cruz</NavDropdown.Item>
                        <NavDropdown.Item href="/brand/scott">Scott</NavDropdown.Item>
                        <NavDropdown.Item href="/brand/specialized">Specialized</NavDropdown.Item>
                        <NavDropdown.Item href="/brand/yeti">Yeti</NavDropdown.Item>
                    </NavDropdown>
                </Nav>
                </Navbar.Collapse>
            </Navbar>
        </>
    )
}
/*
{
        "category": "mountain",
        "subcategory": "hardtail"
    },
    {
        "category": "road",
        "subcategory": "racing"
    },
    {
        "category": "hybrid",
        "subcategory": "commuter"
    },
    {
        "category": "electric",
        "subcategory": "mountain"
    },
    {
        "category": "bmx",
        "subcategory": "freestyle"
    },
    {
        "category": "mountain",
        "subcategory": "trail"
    },
    {
        "category": "mountain",
        "subcategory": "enduro"
    },
    {
        "category": "mountain",
        "subcategory": "cross country"
    }
*/
export { MenuBar }