<?php

declare(strict_types=1);

namespace App\Test;

use PHPUnit\Framework\TestCase;
use App\AreaCalculator;

class AreaCalculatorTest extends TestCase
{
    public function testCalculateSquareArea(): void
    {
        $calculator = new AreaCalculator();

        $this->assertEquals(4, $calculator->calculateSquareArea(2));
    }
}
