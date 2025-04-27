import * as React from 'react';
import { Item } from './model/item';
import { Card } from 'react-bootstrap';


function ItemList({items}: {items: Item[]}) {

  return (
    <div>
      <div className='row'>
        {items.map(item => (
          <React.Fragment key={item.id}>
            <Card className='col-3'>
              <Card.Img variant="top" src={ "/images/" + item.thumb} />
              <Card.Body>
                <Card.Title>{item.name}</Card.Title>
                <Card.Text>
                  {item.description}
                </Card.Text>
                <Card.Text>
                  Price: {item.price}
                </Card.Text>
                <Card.Link href={`/item/${item.category}/${item.id}`} className="btn btn-primary">Details</Card.Link>
              </Card.Body>
            </Card>
          </React.Fragment>
        ))}
      </div>
    </div>
  )
}

export { ItemList }
