import * as React from 'react';
import { useState, useEffect } from 'react'
import Col from 'react-bootstrap/Col';
import { useParams } from "react-router";
import { ItemList } from '../ItemList';
import { Item } from '../model/item';

function Brand() {

    const [items, setItems] = useState<Item[]>([])
    const  param  = useParams();

    useEffect(() => {
        fetchItems()
    }, [])

    const fetchItems = async () => {
        try {

        const response = await fetch('/api/brands/' + param.brand)
        const data = await response.json()
            if (!response.ok) {
                throw new Error('Network response was not ok')
            }
        setItems(data.items)
        } catch (error) {
        console.error('Error fetching items:', error)
        }
    }
  
  return (
    <>
        <Col md={12} className='bg-light'>
            <hr></hr>
            <ItemList items={items} ></ItemList>
        </Col>
    </>
  )
}

export { Brand }

