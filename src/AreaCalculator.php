<?php

declare(strict_types=1);

namespace App;

class AreaCalculator
{
    public function calculateSquareArea(int $lengthOfSide): float
    {
        return $lengthOfSide * $lengthOfSide;
    }
}
